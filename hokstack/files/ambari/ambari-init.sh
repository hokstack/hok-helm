#!/bin/bash

export TERM=xterm

while ! nslookup postgres-0 > /dev/null || ! nc -w1 postgres-0 5432 > /dev/null; do
    tput cuu1
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Waiting for Ambari to Come up!"
    sleep 0.1
done
sleep 10
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Postgres is up, Will be starting Ambari"
