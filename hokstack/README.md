# HokStack - Hadoop On Kubernetes

<p align="center">
  <img width="700" height="300" src="https://raw.githubusercontent.com/hokstack/hok-helm/master/images/cover.png">
</p>


## Overview

HoK is Hadoop on Kubernetes, It helps you to deploy Hadoop stack on Kubernetes

Kubernetes is now proven technology to deploy and distribute modules quickly and efficiently. Many cloud vendors are now offering Hadoop as a service. Companies are moving towards the model where they want to provision an instance of service on the fly and use it for analytics. Usually, it takes weeks to provision a production-ready Hadoop cluster. This platform is container-native platform serves as the Backbone for all other analytical services. This provides the user to spawn Hadoop cluster using the self-serve portal, which helps them to onboard the team quickly and efficiently so their developers can start using the cluster as soon as they join the team

<p align="center">
  <img width="600" height="500" src="https://raw.githubusercontent.com/hokstack/hok-helm/master/images/hok-overview.png">
</p>

## Installation

### Helm

This Helm Chart requires Helm 2.

### Platforms
Depending of the version of the HoKStack, it supports the following platforms:

| HoKStack Helm Chart version        | Kubernetes | OpenShift Container Platform |
| ---------------------------------------------- | ---------- | ---------------------------- |
| v1.0.0                                         | 1.11+      | 3.11+                        |
| v1.0.0                                         | 1.11+      | 3.11+                        |


### Quick Start

The Hok need saperet namespace which can be `team-name` or `value-stream` anything unique.
It deploys all the Hadoop components in statefulsets.
To install the HokStack via Helm run the following command:

### Adding Hadoop on Kubernetes repository
```
$ helm repo add hok https://raw.githubusercontent.com/hokstack/hok-helm/master/repos/stable
```

### Update procedure

To update simply update your helm repositories and check the latest version

```
$ helm repo update
```
### Repo search

You can then check for the latest version by searching your Helm repositories for the HokStack

```
$ helm search hok 
```

### Rollout for first team with default values

You can then check for the latest version by searching your Helm repositories for the HokStack

```
$ helm install hok/hokstack --name hok-team1 --set teamname=team1 --namespace team1
```

### Rollout for second team with default values

You can then check for the latest version by searching your Helm repositories for the HokStack

```
$ helm install hok/hokstack --name hok-team2 --set teamname=team2 --set metacontroller.crds.create=false --namespace team2
```

### Remove hadoop-on-kubernetes

Remove OneAgent custom resources and clean-up all remaining OneAgent Operator specific objects:

```
$ helm remove <release name> -n <namespace>
```

## HDP Statefulsets Detail

By default it will install following statefulsets.

 * postgres
 * ambariserver
 * masternode 
 * datanode `3 replica`
 * edgenode
 * dante-proxy 
 * kdcserver `optional`
 * metacontroller
 
 <p align="left">
  <img width="600" height="300" src="https://raw.githubusercontent.com/hokstack/hok-helm/master/images/hok-deployed.gif">
</p>

## Component will be installed
 * HDFS
 * Yarn
 * Mapreduce
 * Tez
 * Hive
 * Oozie
 * ZooKeeper
 * Kafka
 * Spark
 * Spark2

 <p align="left">
  <img width="700" height="400" src="https://raw.githubusercontent.com/hokstack/hok-helm/master/images/hok-ambari-dash.gif">
</p>

## Need more components?

[hdfsyarn.json](https://raw.githubusercontent.com/hokstack/hok-helm/master/hokstack/files/ambari/hdfsyarn.json) contains the ambari blueprints, add componenets in the `host_groups` to add more HDP componenets.


## Accessing Cluster UI
In the stack, you will find dante-proxy pod is running its SOCKS5 proxy running in container using that you can access the Ambari UI and other Hadoop UIs.

Get the NodePort of dante-proxy using below command
```
$ kubectl get svc dante-proxy
```
Enter this port and Node IP address to the web-browser in proxy section, preferably `Firefox` as nowadays Chrome manages my orgnisations.

 <p align="left">
  <img width="300" height="300" src="https://raw.githubusercontent.com/hokstack/hok-helm/master/images/sock5-settings.png">
</p>

## Accessing Cluster and submiting Jobs

Acces cluster using the edgenode port you can login into that using

```
kubectl exec -it edgenode-0 bash
```

Aslo SSH is enabled on the edgenode-0 it can be accessed

## Helm chart Configuration

The following table lists the configurable parameters of the HELM chart and their default values.

Global values

| Parameter                                         | Description                                           | Default                               |
|---------------------------------------------------|-------------------------------------------------------|---------------------------------------|
| `teamname`                                        | Team name value to seprate the install                | team1                                 |

#### PostgreSQL values   

| Parameter                                         | Description                                           | Default                               |
|---------------------------------------------------|-------------------------------------------------------|---------------------------------------|
| `postgres.enabled`                                | Flag to enable and disable Postgres SQL install       | `true`                                |
| `postgres.name`                                   | The name used in various properties                   | `postgres`                            |
| `postgres.replicaCount`                           | Postgres pod replica count                            | `1`                                   |
| `postgres.image.repository`                       | Image repo URL `It uses custom postgres image`        | `index.docker.io/rohitrsh/postgresql` |
| `postgres.persistentVolume.enabled`               | The PVC enable flag to control volumes                | `true`                                |
| `postgres.storageClassName`                       | The storage class to be used for PVC                  | `gp2` - In the case of EKS            |
| `postgres.persistentVolume.accessModes`           | PVC access mode                                       | `ReadWriteOnce`                       |
| `postgres.persistentVolume.storage`               | The storage size to be allocated to pod               | `10Gi`                                |

### Ambari Server Values    

| Parameter                                         | Description                                           | Default                               |
|---------------------------------------------------|-------------------------------------------------------|---------------------------------------|
| `ambariserver.enable`                             | Flag to enable and disable Ambari Server Install      | `true`                                |
| `ambariserver.name`                               | The name used in various properties                   | `ambariserver`                        |
| `ambariserver.componentName`                      | The component name used in various properties         | `ambari`                              |
| `ambariserver.image.repository`                   | Image repo URL `It uses custom ambari image`          | `index.docker.io/rohitrsh/hdp`        |
| `ambariserver.persistentVolume.enabled`           | The PVC enable flag to control volumes                | `true`                                |
| `ambariserver.persistentVolume.storageClassName`  | The storage class to be used for PVC                  | `gp2` In the case of EKS              |
| `ambariserver.persistentVolume.accessModes`       | PVC access mode                                       | `ReadWriteOnce`                       |
| `ambariserver.persistentVolume.storage`           | The storage size to be allocated to pod               | `1Gi`                                 |

### Master Node Values  

| Parameter                                         | Description                                           | Default                               |
|---------------------------------------------------|-------------------------------------------------------|---------------------------            |
| `masternode.enable`                               | Flag to enable and disable Master Node Install        | `true`                                |
| `masternode.name`                                 | The name used in various properties                   | `masternode`                          |
| `masternode.componentName`                        | The component name used in various properties         | `master`                              |
| `masternode.image.repository`                     | Image repo URL `It uses custom hdp image`             | `index.docker.io/rohitrsh/hdp`        |
| `masternode.persistentVolume.enabled`             | The PVC enable flag to control volumes                | `true`                                |
| `masternode.persistentVolume.storageClassName`    | The storage class to be used for PVC                  | `gp2` In the case of EKS              |
| `masternode.persistentVolume.accessModes`         | PVC access mode                                       | `ReadWriteOnce`                       |             
| `masternode.persistentVolume.storage`             | The storage size to be allocated to pod               | `10Gi`                                |
| `masternode.persistentVolume.mountPath`           | The storage mount path will be used by HDFS           | `/hadoop`              
            
### Data Node Values            
            
| Parameter                                         | Description                                           | Default                               |
|---------------------------------------------------|-------------------------------------------------------|---------------------------            |
| `datanode.enable`                                 | Flag to enable and disable Data Node Install          | `true`                                |
| `datanode.name`                                   | The name used in various properties                   | `datanoe`                             |
| `datanode.componentName`                          | The component name used in various properties         | `data`                                |
| `datanode.image.repository`                       | Image repo URL `It uses custom hdp image`             | `index.docker.io/rohitrsh/hdp`        |
| `datanode.persistentVolume.enabled`               | The PVC enable flag to control volumes                | `true`                                |
| `datanode.persistentVolume.storageClassName`      | The storage class to be used for PVC                  | `gp2` In the case of EKS              |
| `datanode.persistentVolume.accessModes`           | PVC access mode                                       | `ReadWriteOnce`                       |             
| `datanode.persistentVolume.storage`               | The storage size to be allocated to pod               | `10Gi`                                |
| `datanode.persistentVolume.mountPath`             | The storage mount path will be used by HDFS           | `/hadoop`                                
            
### Edge Node Values
            
| Parameter                                         | Description                                           | Default                               |
|---------------------------------------------------|-------------------------------------------------------|---------------------------            |
| `edgenode.enable`                                 | Flag to enable and disable Edge Node Install          | `true`                                |
| `edgenode.name`                                   | The name used in various properties                   | `edgenode`                            |
| `edgenode.componentName`                          | The component name used in various properties         | `edge`                                |
| `edgenode.image.repository`                       | Image repo URL `It uses custom hdp image`             | `index.docker.io/rohitrsh/hdp`        |
| `edgenode.persistentVolume.enabled`               | The PVC enable flag to control volumes                | `true`                                |
| `edgenode.persistentVolume.storageClassName`      | The storage class to be used for PVC                  | `gp2` In the case of EKS              |
| `edgenode.persistentVolume.accessModes`           | PVC access mode                                       | `ReadWriteOnce`                       |             
| `edgenode.persistentVolume.storage`               | The storage size to be allocated to pod               | `10Gi`                                |
| `edgenode.persistentVolume.mountPath`             | The storage mount path will be used by HDFS           | `/hadoop`                                
            
### Metacontroller Values             
            
| Parameter                                         | Description                                           | Default                               |
|---------------------------------------------------|-------------------------------------------------------|---------------------------            |
| `metacontroller.enable`                           | Flag to enable and disable Metacontroller Install     | `true`                                |
| `metacontroller.name`                             | The name used in various properties                   | `metacontroller`                      |
| `metacontroller.image.repository`                 | Image repo URL                                        | `metacontroller/metacontroller`       |
| `metacontroller.rbac.create`                      | RBAC creation for metacontroller                      | `true`                                |
| `metacontroller.serviceAccount.create`            | Service Account creation for metacontroller           | `true`                                | 
| `metacontroller.crds.create`                      | CRDs install for metacontroller                       | `truw`                                
            
### Kerberose Values            
            
| Parameter                                         | Description                                           | Default                               |
|---------------------------------------------------|-------------------------------------------------------|---------------------------            |
| `kdc.enable`                                      | Flag to enable and disable Edge Node Instal           | `true`                                |
| `kdc.name`                                        | The name used in various properties                   | `kdcserve`                            |
| `kdc.componentName`                               | The component name used in various properties         | `kdc`                                 |
| `kdc.realmName`                                   | The kerberos REALM name                               | `DEMO.COM`                            |
| `kdc.image.repository`                            | Image repo URL                                        | `index.docker.io/rohitrsh/kdc`   |
| `kdc.persistentVolume.enabled`                    | The PVC enable flag to control volumes                | `true`                                |
| `kdc.persistentVolume.storageClassName`           | The storage class to be used for PVC                  | `gp2` In the case of EKS              |
| `kdc.persistentVolume.accessModes`                | PVC access mode                                       | `ReadWriteOnce`                       | 
| `kdc.persistentVolume.storage`                    | The storage size to be allocated to pod               | `10Gi`                                |                

Full and up-to-date documentation can be found in the comments of the `values.yaml` file.



## About Us

HokStack is maintained by:

* [Rohit Sharma](https://www.linkedin.com/in/rohitrsh/) ([@rohitrsh](https://twitter.com/rohitrsh))
* [Shubhomoy Biswas](https://www.linkedin.com/in/shubhomoybiswas//) ([@shubhmoy](https://twitter.com/))

## Credits

Initially inspired from https://www.cloudera.com/tutorials/getting-started-with-hdp-sandbox.html

## Contributing

Currently we work on the code in our free time, any assistance is highly appreciated. Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests.


## License

HoKStack is under Apache 2.0 license. See [LICENSE.md](LICENSE.md) for details.
