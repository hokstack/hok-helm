#!/bin/bash

export TERM=xterm

while ! nslookup ambariserver-0 > /dev/null || ! nc -w1 ambariserver-0 8080 > /dev/null; do
    tput cuu1
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Waiting for Ambari to Come up!"
    sleep 0.1
done
sleep 80
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Ambari is up, Will be starting Data Node"
