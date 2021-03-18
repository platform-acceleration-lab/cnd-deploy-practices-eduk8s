#!/bin/bash

export EDUCATES_VERSION="develop"

DIR=$(dirname $0)

if kubectl get trainingportals.training.eduk8s.io > /dev/null 2>&1; then
    kubectl delete trainingportals.training.eduk8s.io --all
    kubectl delete workshops.training.eduk8s.io --all
    kubectl delete workshopsessions.training.eduk8s.io --all    
else
    echo "===== Installing educates"
    kubectl apply -k "github.com/eduk8s/eduk8s?ref=$EDUCATES_VERSION"
    IPADDRESS="$(ifconfig | grep 'broadcast\|Bcast' | awk -F ' ' {'print $2'} | head -n 1 | sed -e 's/addr://g')"
    if [ -z "$IPADDRESS" ]
    then
        IPADDRESS="$(hostname -I |grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' |head -n 1)" # workaround if ifconfig is not installed on recent versions of Debian
    fi

    echo "===== Setting Ingress Domain to ${IPADDRESS}.nip.io"
    kubectl set env deployment/eduk8s-operator -n eduk8s INGRESS_DOMAIN="${IPADDRESS}.nip.io"
fi

echo "===== Installing the workshop and training portal"
kubectl apply -f $DIR

echo "===== Waiting for Trainging Portal to be Ready"
while true; do
    if [[ `kubectl get trainingportals.training.eduk8s.io --no-headers` =~ "Running" ]]
    then
        echo ""
        echo "===== Training Portal is now reading"
        kubectl get trainingportals.training.eduk8s.io
        break
    fi
    echo -n "."
    sleep 3
done