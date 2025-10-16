ActiveMQ Helm Chart

This chart deploys Apache ActiveMQ Classic as a StatefulSet with a ConfigMap, Secret, Service, PVC and optional Ingress.

Quick install:

1. Install with default values (creates PVC named `activemq-shared-data` if persistence.enabled=true):

   helm install activemq ./activemq

2. To override values:

   helm install activemq ./activemq -f myvalues.yaml

Notes:
- The chart uses a PersistentVolumeClaim by default. Set `persistence.existingClaim` if you already have a PVC.
- The chart creates a ServiceAccount, Role and RoleBinding. Set `serviceAccount.create=false` to skip creation.
- Ingress is disabled by default. Configure `ingress.enabled=true` and set `ingress.host`.

Limitations:
- I couldn't run `helm lint` in this environment. Please run `helm lint ./activemq` locally to validate templates.
