# Accumulo Installation
This is the installation guide for an Apache Accumulo Database in an Ubuntu Server 22.04 LTS.

## Prerequisites
- Apache HDFS (Hadoop)
- Apache ZooKeeper

### Apache HDFS
Source: [https://github.com/kon-si/ntua_atds/tree/master/setup#hdfs-installation]
#### Passwordless SSH Connectivity
Apache Hadoop HDFS uses SSH keys for passwordless authentication Hadoop an our server.
~~~
mkdir ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
~~~

### Apache ZooKeeper


```
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/tigera-operator.yaml <br />
kubectl create -f calico-config.yaml <br />
```

`kubectl create -f calico-config.yaml`
