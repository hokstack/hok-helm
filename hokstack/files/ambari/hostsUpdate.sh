#!/bin/bash
echo "Generating hosts entries"
curl --silent --user hokstack:h0kStack http://{{ .Values.ambariserver.name }}-0:8080/api/v1/clusters/{{ .Values.teamname }}/hosts?fields=Hosts/host_name,Hosts/ip |jq -r '.items[] | [.Hosts.ip,.Hosts.host_name] |join("\t")' | tee /tmp/hosts

cat /tmp/hosts  | while read host; do hosts add  $host; done