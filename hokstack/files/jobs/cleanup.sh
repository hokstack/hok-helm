#!/bin/bash

function create_kubeconfig() {
    # export KUBECONFIG=./hok
    API_SERVER="https://${KUBERNETES_PORT_443_TCP_ADDR}:443"
    TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
    CA_FILE="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
    kubectl config set-cluster hok --server=$API_SERVER --certificate-authority=$CA_FILE --embed-certs=true
    kubectl config set-credentials hok-admin --token=$TOKEN
    kubectl config set-context hok --cluster hok --user hok-admin
    kubectl config use-context hok
}

function remove_statefulsets() {
    for i in $(kubectl get sts -n $NAMESPACE |awk '{print $1}'|grep -iv name); do 
        kubectl patch sts $i -p '{"metadata":{"finalizers":null}}' -n $NAMESPACE;
        kubectl delete sts $i --grace-period=0 --force -n $NAMESPACE;
    done;
}

function remove_pvc() {
    for i in $(kubectl get pvc -n $NAMESPACE |awk '{print $1}'|grep -iv name); do 
        kubectl delete pvc  $i -n $NAMESPACE;
    done;
}


if [ "{{.Values.cleanup.enabled}}" == "true" ]; then
    create_kubeconfig
fi

if [ "{{.Values.cleanup.removestatefulest.enabled}}" == "true" ]; then
    remove_statefulsets
fi

if [ "{{.Values.cleanup.removepvc.enabled}}" == "true" ]; then
    remove_pvc
fi