set -e

echo "Building, pushing and restarting webhoo..."
./bin/docker-compose.sh

kubectl rollout restart deployment -n test-webhook test-webhook

sleep 10
kubectl rollout restart deployment -n test test-pod
