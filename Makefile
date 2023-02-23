export GOOS = linux
export GOARCH = amd64

build:
	go build -o test-webhook

docker-build:
	docker build -t test-webhook .

docker-compose:
	docker-compose build && docker-compose push

local-docker-env:
	docker run -it --rm -v $PWD:/app -p 8443:8443 golang:1.19-alpine

setup-kind-testing:
	./bin/_setup-kind-testing.sh

create-kind:
	./bin/local-kind-cluster/create.sh

deploy-cert-manager:
	./bin/cert-mgmt.sh

redeploy:
	./bin/_redeploy.sh

port-forward:
	kubectl port-forward -n test-webhook svc/test-webhook 8443:443
