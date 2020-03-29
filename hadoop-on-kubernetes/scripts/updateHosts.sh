#!/bin/bash

if [ $# != 1 ]
then
    echo "namespace required"
    exit 10
fi

NAMESPACE=${1}

echo 'adding namespaces to /tmp/hosts'
echo $(kubectl get pods -n ${NAMESPACE} -owide | awk 'NR>1 { print $6, $1".'${NAMESPACE}'", $1 >> "/tmp/hosts"}') 

echo 'Copying to namespaces'
for POD in $(kubectl get pods -n ${NAMESPACE} | awk 'NR>1{ print $1 }')
do
    echo "Copying and Updating hosts file on:- $POD"
    kubectl cp /tmp/hosts ${NAMESPACE}/$POD:/tmp/hosts
    kubectl exec -it $POD -n ${NAMESPACE} -- bash -c "cat /tmp/hosts >> /etc/hosts" 
done

rm /tmp/hosts

