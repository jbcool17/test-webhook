helm repo add jetstack https://charts.jetstack.io

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.9.1 \
  --set installCRDs=true


# ---
# # Source: nri-metadata-injection/templates/service.yaml
# apiVersion: v1
# kind: Service
# metadata:
#   name: release-name-nri-metadata-injection
#   namespace: default
#   labels:
#     app.kubernetes.io/instance: release-name
#     app.kubernetes.io/managed-by: Helm
#     app.kubernetes.io/name: nri-metadata-injection
#     app.kubernetes.io/version: 1.7.3
#     helm.sh/chart: nri-metadata-injection-3.0.8
# spec:
#   ports:
#   - port: 443
#     targetPort: 8443
#   selector:
#     app.kubernetes.io/instance: release-name
#     app.kubernetes.io/name: nri-metadata-injection
# ---
# # Source: nri-metadata-injection/templates/deployment.yaml
# apiVersion: apps/v1
# kind: Deployment
# metadata:
#   name: release-name-nri-metadata-injection
#   namespace: default
#   labels:
#     app.kubernetes.io/instance: release-name
#     app.kubernetes.io/managed-by: Helm
#     app.kubernetes.io/name: nri-metadata-injection
#     app.kubernetes.io/version: 1.7.3
#     helm.sh/chart: nri-metadata-injection-3.0.8
# spec:
#   replicas: 1
#   selector:
#     matchLabels:
#       app.kubernetes.io/name: nri-metadata-injection
#   template:
#     metadata:
#       labels:
#         app.kubernetes.io/instance: release-name
#         app.kubernetes.io/name: nri-metadata-injection
#     spec:
#       securityContext:
#         fsGroup: 1001
#         runAsUser: 1001
#         runAsGroup: 1001
#       hostNetwork: false
#       containers:
#       - name: nri-metadata-injection
#         image: "newrelic/k8s-metadata-injection:1.7.3"
#         imagePullPolicy: IfNotPresent
#         env:
#         - name: clusterName
#           value: kind
#         ports:
#           - containerPort: 8443
#             protocol: TCP
#         volumeMounts:
#         - name: tls-key-cert-pair
#           mountPath: /etc/tls-key-cert-pair
#         readinessProbe:
#           httpGet:
#             path: /health
#             port: 8080
#           initialDelaySeconds: 1
#           periodSeconds: 1
#         resources:

#           limits:
#             memory: 80M
#           requests:
#             cpu: 100m
#             memory: 30M
#       volumes:
#       - name: tls-key-cert-pair
#         secret:
#           secretName: release-name-nri-metadata-injection-admission
# ---
# # Source: nri-metadata-injection/templates/cert-manager.yaml
# # Generate a CA Certificate used to sign certificates for the webhook
# apiVersion: cert-manager.io/v1
# kind: Certificate
# metadata:
#   name: release-name-nri-metadata-injection-root-cert
#   namespace: default
# spec:
#   secretName: release-name-nri-metadata-injection-root-cert
#   duration: 43800h # 5y
#   issuerRef:
#     name: release-name-nri-metadata-injection-self-signed-issuer
#   commonName: "ca.webhook.nri"
#   isCA: true
# ---
# # Source: nri-metadata-injection/templates/cert-manager.yaml
# # Finally, generate a serving certificate for the webhook to use
# apiVersion: cert-manager.io/v1
# kind: Certificate
# metadata:
#   name: release-name-nri-metadata-injection-webhook-cert
#   namespace: default
# spec:
#   secretName: release-name-nri-metadata-injection-admission
#   duration: 8760h # 1y
#   issuerRef:
#     name: release-name-nri-metadata-injection-root-issuer
#   dnsNames:
#   - release-name-nri-metadata-injection
#   - release-name-nri-metadata-injection.default
#   - release-name-nri-metadata-injection.default.svc
# ---
# # Source: nri-metadata-injection/templates/cert-manager.yaml
# # Create a selfsigned Issuer, in order to create a root CA certificate for
# # signing webhook serving certificates
# apiVersion: cert-manager.io/v1
# kind: Issuer
# metadata:
#   name: release-name-nri-metadata-injection-self-signed-issuer
#   namespace: default
# spec:
#   selfSigned: {}
# ---
# # Source: nri-metadata-injection/templates/cert-manager.yaml
# # Create an Issuer that uses the above generated CA certificate to issue certs
# apiVersion: cert-manager.io/v1
# kind: Issuer
# metadata:
#   name: release-name-nri-metadata-injection-root-issuer
#   namespace: default
# spec:
#   ca:
#     secretName: release-name-nri-metadata-injection-root-cert
# ---
# # Source: nri-metadata-injection/templates/admission-webhooks/mutatingWebhookConfiguration.yaml
# apiVersion: admissionregistration.k8s.io/v1
# kind: MutatingWebhookConfiguration
# metadata:
#   name: release-name-nri-metadata-injection
#   annotations:
#     certmanager.k8s.io/inject-ca-from: "default/release-name-nri-metadata-injection-root-cert"
#     cert-manager.io/inject-ca-from: "default/release-name-nri-metadata-injection-root-cert"
#   labels:
#     app.kubernetes.io/instance: release-name
#     app.kubernetes.io/managed-by: Helm
#     app.kubernetes.io/name: nri-metadata-injection
#     app.kubernetes.io/version: 1.7.3
#     helm.sh/chart: nri-metadata-injection-3.0.8
# webhooks:
# - name: metadata-injection.newrelic.com
#   clientConfig:
#     service:
#       name: release-name-nri-metadata-injection
#       namespace: default
#       path: "/mutate"
#   rules:
#   - operations: ["CREATE"]
#     apiGroups: [""]
#     apiVersions: ["v1"]
#     resources: ["pods"]
#   failurePolicy: Ignore
#   timeoutSeconds: 28
#   sideEffects: None
#   admissionReviewVersions:
#   - v1beta1
#   - v1
