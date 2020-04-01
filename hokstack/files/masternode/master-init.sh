#!/bin/bash
while ! nslookup ambariserver-0 </dev/null || ! nc -w1 ambariserver-0 8080 </dev/null; do
    echo "Waiting for Ambari to Come up!"
    sleep 0.1
done
sleep 60
echo "Ambari Up, Will be starting Master"
