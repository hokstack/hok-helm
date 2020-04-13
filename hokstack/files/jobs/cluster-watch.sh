#!/bin/bash

export TERM=xterm

while ! nslookup ambariserver-0 > /dev/null || ! nc -w1 ambariserver-0 8080 > /dev/null; do
    tput cuu1
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Waiting for Ambari to Come up!"
    sleep 2
done
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Ambari is up, Checking for cluster installation."

FirstReq=$(curl -s --user admin:admin -H 'X-Requested-By:ambari' -X GET http://$AMBARISERVER:8080/api/v1/clusters/$NAMESPACE/requests/1 |jq .status)
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Cluster request 1 HTTP code is $FirstReq"

while [[ $FirstReq == 404 ]]; do
  FirstReq=$(curl -s --user admin:admin -H 'X-Requested-By:ambari' -X GET http://$AMBARISERVER:8080/api/v1/clusters/$NAMESPACE/requests/1 |jq .status)
  tput cuu1
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Waiting for cluster installation invocation"
  sleep 2
done

ProgressPercent=`curl -s --user admin:admin -H 'X-Requested-By:ambari' -X GET http://$AMBARISERVER:8080/api/v1/clusters/$NAMESPACE/requests/1 | grep progress_percent | awk '{print $3}' | cut -d . -f 1`
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Installation progress: $ProgressPercent"

while [[ `echo $ProgressPercent | grep -v 100` ]]; do
  ProgressPercent=`curl -s --user admin:admin -H 'X-Requested-By:mycompany' -X GET http://$AMBARISERVER:8080/api/v1/clusters/$NAMESPACE/requests/1 | grep progress_percent | awk '{print $3}' | cut -d . -f 1`
  tput cuu1
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Installation of $NAMESPACE cluster in progress: $ProgressPercent %"
  sleep 2
done
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $NAMESPACE cluster build is complete."
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Updating the latest /etc/hosts across the cluster."
curl --silent -u hokstack:h0kStack -X POST -H 'X-Requested-By:ambari' -d'{"RequestInfo":{"context":"Updating /etc/hosts file", "action" : "update_hosts", "service_name" : "", "component_name":"", "hosts":"ambariserver-0"}}' http://$AMBARISERVER:8080/api/v1/clusters/$NAMESPACE/requests