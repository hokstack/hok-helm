kubectl patch sts datanode -p '{"metadata":{"finalizers":null}}'
kubectl delete sts datanode --grace-period=0 --force

kubectl patch pod datanode-0 -p '{"metadata":{"finalizers":null}}'
kubectl patch pod datanode-1 -p '{"metadata":{"finalizers":null}}'
kubectl patch pod datanode-2 -p '{"metadata":{"finalizers":null}}'

kubectl delete pods datanode-0 datanode-1 datanode-2 --grace-period=0 --force
