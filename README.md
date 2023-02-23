# test webhook

- testing and understanding kubernetes webhooks
- get and output admissionReview webhook body

## Testing

### Requirements

- docker
- kind
- helm - cert manager

### Kind Cluster Test

- ???

- CLEANUP: `kind delete cluster`

### Local Test

./certs/certs.sh

```go
flag.StringVar(&tlscert, "tlscert", "certs/webhook-server-tls.crt", "Path to the TLS certificate")
flag.StringVar(&tlskey, "tlskey", "certs/webhook-server-tls.key", "Path to the TLS key")
```

# test-webhook
