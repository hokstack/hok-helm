#!/bin/bash
while ! nslookup postgres-0 </dev/null || ! nc -w1 postgres-0 5432 </dev/null; do
    echo "Waiting for Postgres to Come up!"
    sleep 0.1
done
sleep 10
echo "Postgres Up, Will be starting Ambari"
