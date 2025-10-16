{{- define "activemq.fullname" -}}
{{- printf "%s" .Release.Name }}
{{- end -}}

{{- define "activemq.labels" -}}
app.kubernetes.io/name: {{ include "activemq.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: Helm
{{- end -}}
