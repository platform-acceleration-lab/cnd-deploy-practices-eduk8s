#!/bin/bash

NAME="cnd-deploy-practices"
DIR=$(dirname $0)
if [ $1 == "stop" ]
then
    kind delete cluster --name "${NAME}"
    exit
fi

echo "===== Cleaning up any old clusters"
kind delete cluster --name "${NAME}" > /dev/null 2>&1 || true

echo "===== Creating cluster"
kind create cluster --name "${NAME}" --config $DIR/kind-config.yaml

echo "===== Loading image into cluster"
kind load docker-image --name "${NAME}" ${NAME}:latest
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
sleep 10
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
