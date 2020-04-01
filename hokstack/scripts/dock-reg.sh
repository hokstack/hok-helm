export DOCKER_REGISTRY_SERVER="https://index.docker.io/v1/"
export DOCKER_USER="user"
export DOCKER_EMAIL="user@example.com"
export DOCKER_PASSWORD="password"

kubectl create secret docker-registry myregistrykey \
  --docker-server=$DOCKER_REGISTRY_SERVER \
  --docker-username=$DOCKER_USER \
  --docker-password=$DOCKER_PASSWORD \
  --docker-email=$DOCKER_EMAIL
