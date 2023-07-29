# Accumulo Installation
This is the installation guide for an Apache Accumulo 1.10.3 Database in an Ubuntu Server 22.04 LTS, that acts as a node in a Trino cluster. The server's IPv4 address within the local network that connects the 3 Trino nodes is 192.168.0.2.

## [Prerequisites](https://accumulo.apache.org/release/accumulo-1.10.0/#minimum-requirements)
- Java 17 (Accumulo requires version Java 8 or higher. We choose version 17 because of Trino requirements.)
- Apache Hadoop 3.0.3 (HDFS)
- Apache ZooKeeper 3.4.14

### Java
```
sudo apt-get -y install openjdk-17-jdk-headless
```
After installing Java we add the JAVA_HOME environment variable, which contains the installation directory, to the shell environment file .bashrc.
```
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
```

### Apache Hadoop
Source: https://github.com/kon-si/ntua_atds/tree/master/setup#hdfs-installation

#### Configuring Passwordless SSH Connectivity
Apache Hadoop HDFS uses SSH keys for passwordless authentication between Hadoop and our server.
```
mkdir ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat .ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```

#### Installing Hadoop
```
wget https://archive.apache.org/dist/hadoop/common/hadoop-3.0.3/hadoop-3.0.3.tar.gz
tar -xzf hadoop-3.0.3.tar.gz 
mv hadoop-3.0.3 hadoop
```

#### Adding Hadoop Environment Variables
We add the Hadoop environment variables to the shell environment file .bashrc.
```
export HADOOP_HOME=/home/user/hadoop
export PATH=$PATH:$HADOOP_HOME/bin
export PATH=$PATH:$HADOOP_HOME/sbin
export HADOOP_COMMON_HOME=${HADOOP_HOME}
export HADOOP_HDFS_HOME=${HADOOP_HOME}
```
And the JAVA_HOME environment variable, which contains the installation directory, to hadoop/etc/hadoop/hadoop-env.sh.
```
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
```
#### Creating the Data Folder
We create the data folder where the HDFS Datanode will store its data.
```
sudo mkdir -p /usr/local/hadoop/hdfs/data
sudo chown user:user -R /usr/local/hadoop/hdfs/data
chmod 700 /usr/local/hadoop/hdfs/data
```

#### Configuring Hadoop
To configure Hadoop we add code to the following files:
- hadoop/etc/hadoop/core-site.xml
```
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://192.168.0.2:9000</value>
    </property>
</configuration>
```
- hadoop/etc/hadoop/hdfs-site.xml
```
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>file:///usr/local/hadoop/hdfs/data</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>file:///usr/local/hadoop/hdfs/data</value>
    </property>
</configuration>
```
- hadoop/etc/hadoop/yarn-site.xml
```
<configuration>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
        <value>org.apache.hadoop.mapred.ShuffleHandler</value>
    </property>
    <property>
       <name>yarn.resourcemanager.hostname</name>
       <value>192.168.0.2</value>
    </property>
</configuration>
```
- hadoop/etc/hadoop/mapred-site.xml
```
<configuration>
    <property>
        <name>mapreduce.jobtracker.address</name>
        <value>192.168.0.2:54311</value>
    </property>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
</configuration>
```
- hadoop/etc/hadoop/masters
```
192.168.0.2
```
- hadoop/etc/hadoop/workers
```
192.168.0.2
```

#### Formating and Starting HDFS
HDFS needs to be formatted like any classical file system.
```
hdfs namenode -format
```
After formating we can start the HDFS server.
```
start-dfs.sh
```

### Apache ZooKeeper
Source: https://zookeeper.apache.org/doc/r3.4.14/zookeeperStarted.html

#### Installing ZooKeeper
```
wget https://archive.apache.org/dist/zookeeper/zookeeper-3.4.14/zookeeper-3.4.14.tar.gz
tar -xzf zookeeper-3.4.14.tar.gz 
mv zookeeper-3.4.14 zookeeper
```

#### Creating the Data Folder
We create the data folder where ZooKeeper will store the in-memory database snapshots and the transaction log of updates to the database.
```
sudo mkdir -p /usr/local/zookeeper/data
sudo chown user:user -R /usr/local/zookeeper/data
chmod 700 /usr/local/zookeeper/data
```

#### Configuring ZooKeeper
To configure ZooKeeper we add code to the following files:
- zookeeper/conf/zoo.cfg
```
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/usr/local/zookeeper/data
clientPort=2181
```

#### Starting ZooKeeper
```
bin/zkServer.sh start
```
