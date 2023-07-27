# Accumulo Installation
This is the installation guide for an Apache Accumulo 1.10.3 Database in an Ubuntu Server 22.04 LTS.

## [Prerequisites](https://accumulo.apache.org/release/accumulo-1.10.0/#minimum-requirements)
- Apache Hadoop 3.0.3 (HDFS)
- Apache ZooKeeper 3.4.14

### Apache Hadoop
Source: https://github.com/kon-si/ntua_atds/tree/master/setup#hdfs-installation

#### Java Installation and Configuration
```
sudo apt-get -y install openjdk-17-jdk-headless
```
After installing Java we add the JAVA_HOME environmental variable, which contains the installation directory,  to the shell environment file .bashrc.
```
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
```

#### Passwordless SSH Connectivity
Apache Hadoop HDFS uses SSH keys for passwordless authentication Hadoop an our server.
```
mkdir ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat .ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```

#### Haddop Installation and Configuration
```
wget https://archive.apache.org/dist/hadoop/common/hadoop-3.0.3/hadoop-3.0.3.tar.gz
tar -xzf hadoop-3.0.3.tar.gz 
mv hadoop-3.0.3 hadoop
```

### Apache ZooKeeper


```
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/tigera-operator.yaml <br />
kubectl create -f calico-config.yaml <br />
```

`kubectl create -f calico-config.yaml`
