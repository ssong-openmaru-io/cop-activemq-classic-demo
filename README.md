# ActiveMQ StatefulSet 배포

이 프로젝트는 StatefulSet을 사용하여 Apache ActiveMQ Classic 버전 5.19.0을 배포하기 위한 Kubernetes 매니페스트를 포함하고 있습니다.

## 프로젝트 구조

- **매니페스트/**
  - **activemq-namespace.yaml**: ActiveMQ 네임스페이스 정의
  - **activemq-account.yaml**: ActiveMQ ServiceAccount, Role, RoleBinding 생성
  - **activemq-secret.yaml**: ActiveMQ 인증 정보 설정
  - **activemq-configmap.yaml**: ActiveMQ 브로커 및 Jetty 설정
  - **activemq-service.yaml**: ActiveMQ 브로커 접근을 위한 헤드리스 서비스
  - **activemq-ingress.yaml**: 웹 콘솔 접근을 위한 Ingress 설정
  - **activemq-statefulset.yaml**: StatefulSet 배포 설정
  - **persistent-volume-claim.yaml**: NFS를 사용한 공유 스토리지 설정

- **데모 애플리케이션/**
  - **activemq-producer.yaml**: ActiveMQ CLI를 사용한 테스트 메시지 생산자
  - **activemq-consumer.yaml**: ActiveMQ CLI를 사용한 테스트 메시지 소비자
  - **api-producer.yaml**: REST API를 사용한 테스트 메시지 생산자
  - **api-consumer.yaml**: REST API를 사용한 테스트 메시지 소비자

## 주요 기능

- StatefulSet을 통한 고가용성
- NFS 지원으로 영구 스토리지 제공
- 보안 기능:
  - ServiceAccount를 통한 RBAC
  - 인증 정보를 통한 보안
  - securityContext를 통한 보안 기본값
- 다중 프로토콜 지원:
  - OpenWire (61616)
  - AMQP (5672)
  - STOMP (61613)
  - MQTT (1883)
  - WebSocket (61614)
- Ingress를 통한 웹 콘솔 접근
- readiness/liveness 프로브를 통한 상태 모니터링

## 사전 요구사항

- Kubernetes 클러스터
- NFS 스토리지 클래스 설정 (`nfs-client`)
- Ingress 컨트롤러 (nginx)

## 배포 방법

1. 네임스페이스 및 RBAC 리소스 생성:
   ```bash
   kubectl apply -f manifests/activemq-namespace.yaml
   kubectl apply -f manifests/activemq-account.yaml
   ```

2. 스토리지 리소스 생성:
   ```bash
   kubectl apply -f manifests/persistent-volume-claim.yaml
   ```

3. 설정 적용:
   ```bash
   kubectl apply -f manifests/activemq-secret.yaml
   kubectl apply -f manifests/activemq-configmap.yaml
   ```

4. ActiveMQ 배포:
   ```bash
   kubectl apply -f manifests/activemq-service.yaml
   kubectl apply -f manifests/activemq-ingress.yaml
   kubectl apply -f manifests/activemq-statefulset.yaml
   ```

## ActiveMQ 접근 방법

- **브로커 접근**: 
  - 클러스터 내부: `activemq.activemq.svc.cluster.local:61616`
  - 지원 프로토콜: OpenWire, AMQP, STOMP, MQTT, WebSocket

- **웹 콘솔**:
  - URL: `http://activemq.apps.oke.mw-oke.local`
  - 기본 인증 정보:
    - 사용자명: admin
    - 비밀번호: admin

## 테스트 방법

### ActiveMQ CLI 사용
```bash
# 생산자 실행
kubectl apply -f demo/activemq-producer.yaml

# 소비자 실행
kubectl apply -f demo/activemq-consumer.yaml
```

### REST API 사용
```bash
# 생산자 실행
kubectl apply -f demo/api-producer.yaml

# 소비자 실행
kubectl apply -f demo/api-consumer.yaml
```

## 보안 고려사항

- 모든 파드는 비root 사용자로 실행 (UID 1000)
- 보안 컨텍스트 적용:
  - 권한 상승 금지
  - 최소 권한 부여
  - 읽기 전용 루트 파일시스템
- 웹 콘솔 접근 시 인증 필요
- Jetty 설정의 보안 기본값 적용