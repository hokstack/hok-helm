# hok-helm

### Installation

Apply the CRD
```sh
$ cd deploy
$ kubectl apply -f crd.yaml
```

Create the ClusterRole, ClusterRoleBinding and ServiceAccount
```sh
$ kubectl apply -f service_account.yaml
$ kubectl apply -f clusterrole.yaml
$ kubectl apply -f cluster_role_binding.yaml
```

Deploy the Operator
```sh
$ kubectl apply -f operator.yaml
```


Deploy the CustomResource -> HadoopOnKubernetes
Make sure to edit the required values.
```sh
$ kubectl apply -f cr.yaml
```
