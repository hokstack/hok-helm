#!/bin/bash
cp -rf /etc/hosts /hosts-new
sed -i '$d' /hosts-new
sed -i '11 s/^/#/' /etc/pam.d/su
echo $PODIP $PODNAME.$NAMESPACE $PODNAME >> /hosts-new
yes|cp -rf /hosts-new /etc/hosts
hostname $PODNAME
echo $PODNAME > /etc/hostname
/scripts/data-ssh-config.sh
echo "AllowUsers *@10.42.*.*" >> sshd_config

curl -u hokstack:h0kStack -X POST -H 'X-Requested-By:ambari' -d'{"RequestInfo":{"context":"Updating /etc/hosts file", "action" : "update_hosts", "service_name" : "", "component_name":"", "hosts":"ambariserver-0"}}' http://$AMBARISERVER:8080/api/v1/clusters/$NAMESPACE/requests

# HOST=$PODNAME.$NAMESPACE
# STATUS=$(curl --silent --user hokstack:h0kStack http://$AMBARISERVER:8080/api/v1/clusters/$NAMESPACE/hosts?fields=Hosts/host_state,Hosts/host_status |jq -r --arg HOST "$HOST" '.items[] | select(.Hosts.host_name==$HOST) | [.Hosts.host_state] | .[]')

# while ([ -z $STATUS ] || [ $STATUS != HEALTHY ]); do
#   echo "Waiting for $HOST status to become HEALTHY!"
#   echo $STATUS
#   sleep 5
# done

# if ([ -z $STATUS ] || [ $STATUS == HEALTHY ]); then
#   echo "Server is $STATUS"
#   cmd=$(curl -u hokstack:h0kStack -X POST -H 'X-Requested-By:ambari' -d'{"RequestInfo":{"context":"Updating /etc/hosts file", "action" : "update_hosts", "service_name" : "", "component_name":"", "hosts":"ambariserver-0"}}' http://$AMBARISERVER:8080/api/v1/clusters/$NAMESPACE/requests)
# fi