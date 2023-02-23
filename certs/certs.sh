#!/usr/bin/env bash

# source: https://github.com/stackrox/admission-controller-webhook-demo/blob/main/deployment/generate-keys.sh


cat >server.conf <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
prompt = no
[req_distinguished_name]
CN = test-webhook-kubernetes-webhook.test-webhook.svc
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = test-webhook-kubernetes-webhook.test-webhook.svc
DNS.2 = localhost
DNS.1 = 127.0.0.1
EOF


# Generate the CA cert and private key
openssl req -nodes -new -x509 -keyout ca.key -out ca.crt -subj "/CN=Admission Controller Webhook" -days 1985
# Generate the private key for the webhook server
openssl genrsa -out webhook-server-tls.key 2048
# Generate a Certificate Signing Request (CSR) for the private key, and sign it with the private key of the CA.
openssl req -days 1985 -new -key webhook-server-tls.key -subj "/CN=test-webhook-kubernetes-webhook.test-webhook.svc" -config server.conf \
    | openssl x509 -req -CA ca.crt -CAkey ca.key -CAcreateserial -out webhook-server-tls.crt -extensions v3_req -extfile server.conf -days 1985
