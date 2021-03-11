#!/bin/bash

NAME="cnd-deploy-practices"
DIR=$(dirname $0)
if [ $1 == "stop" ]
then
    kind delete cluster --name "${NAME}"
    exit
fi

echo "Cleaning up any old clusters"
kind delete cluster --name "${NAME}" > /dev/null 2>&1 || true

echo "Creating cluster"
kind create cluster --name "${NAME}" --config $DIR/kind-config.yaml

echo "Loading image into cluster"
kind load docker-image --name "${NAME}" ${NAME}:latest
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
sleep 10
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

echo "Installing educates"
kubectl apply -k "github.com/eduk8s/eduk8s?ref=develop"
sleep 10
# TODO Wait for educates operator to deploy
# kubectl wait --namespace eduk8s \
#   --for=condition=ready pod \
#   --selector=app.kubernetes.io/component=controller \
#   --timeout=90s

HOST_OS=$(uname)
if [[ "$HOST_OS" == "Linux" ]]; then
    NODE=${NAME}-control-plane
    IPADDRESS=$(kubectl describe node/${NODE} |grep InternalIP|sed 's/  InternalIP:  //g')
elif [[ "$HOST_OS" == "Darwin" ]]; then
    IPADDRESS="$(ifconfig | grep 'broadcast\|Bcast' | awk -F ' ' {'print $2'} | head -n 1 | sed -e 's/addr://g')"
else
    echo "Your OS is not supported"
    exit 1
fi

kubectl set env deployment/eduk8s-operator -n eduk8s INGRESS_DOMAIN="${IPADDRESS}.nip.io"

echo "Installing the workshop and training portal"
kubectl apply -f $DIR/educates/
sleep 10
kubectl get trainingportals.training.eduk8s.io
