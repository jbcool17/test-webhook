# test webhook

- testing and understanding kubernetes webhooks
- get and output admissionReview webhook body

## Testing

### Requirements

- docker
- kind
- helm - cert manager

update `docker-compose.yaml` and deployment yaml with you own docker registry

### Kind Cluster Test

- Setup kind cluster, deploy cert-manager, deploy test-webhook, deploy test deployment: `make setup-kind-testing`
- CLEANUP: `kind delete cluster`

### Local Test

- create certs `./certs/certs.sh`
- `make build`

```go
flag.StringVar(&tlscert, "tlscert", "certs/webhook-server-tls.crt", "Path to the TLS certificate")
flag.StringVar(&tlskey, "tlskey", "certs/webhook-server-tls.key", "Path to the TLS key")
```
