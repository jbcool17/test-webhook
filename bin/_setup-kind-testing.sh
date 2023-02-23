# Docker
# KIND
# HELM / Cert Manager
# Create a testing cluster
set -e

./bin/local-kind-cluster/create.sh

./bin/docker-compose.sh

echo "Waiting for cluster to get setup..."
sleep 5

./bin/cert-mgmt.sh

echo "30...give time for cert-manager to setup..."
sleep 30

echo "Setting up webhook..."
kubectl apply -f deployment/

# sleep 2
echo "30 waiting for webhook to setup..."
sleep 30

echo "Deploying test..."
kubectl apply -f ./bin/local-test-deployment
