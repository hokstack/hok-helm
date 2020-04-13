#!/bin/bash
ambari-server setup --jdbc-db postgres --jdbc-driver=/usr/share/java/postgresql-42.2.2.jar
ambari-server setup --database=postgres --databasehost=$DBHOST --databaseport=5432 --databasename=ambari --postgresschema=ambari  --databaseusername=ambari --databasepassword=dev --silent
ambari-server install-mpack --mpack=/tmp/solr-service-mpack-2.2.9.tar.gz
authconfig --enablemkhomedir --update
sleep 20
ambari-server start
sed -i "s/hostname=localhost/hostname=$PODNAME.$NAMESPACE/" /etc/ambari-agent/conf/ambari-agent.ini
ambari-agent start
while ! nc -z localhost 8080; do
  echo "Waiting for port 8080 to open" && tail -f /var/log/ambari-server/ambari-server.log
  sleep 0.1
done
#Update version defination on Ambari
curl -v -k -u admin:admin -H "X-Requested-By:ambari" -X POST http://localhost:8080/api/v1/version_definitions  -d '{"VersionDefinition": {"version_url": "file:/tmp/HDP-2.6.4.0-91.xml" } }'
#Update Ambari blueprint
curl --user admin:admin -H 'X-Requested-By:admin' -X POST http://localhost:8080/api/v1/blueprints/hdfs --data-binary @/scripts/hdfsyarn.json
curl --user admin:admin -H 'X-Requested-By:admin' -X POST http://localhost:8080/api/v1/clusters/$NAMESPACE --data-binary @/scripts/hdfs.json
curl --user admin:admin -H 'X-Requested-By:admin'  -X POST http://localhost:8080/api/v1/clusters/$NAMESPACE/hosts/$PODNAME.$NAMESPACE
curl -iv -u admin:admin -H "X-Requested-By: ambari" -X POST -d '{"Users/user_name":"hokstack","Users/password":"h0kStack","Users/active":"true","Users/admin":"true"}' http://localhost:8080/api/v1/users 

while true; do
  sleep 3
  tail -f /var/log/ambari-server/ambari-server.log
done