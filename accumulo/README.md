# Accumulo Installation
This is the installation guide for an Apache Accumulo 1.10.3 Database in an Ubuntu Server 22.04 LTS, that acts as a node in a Trino cluster. The server's IPv4 address within the local network that connects the 3 Trino nodes is 192.168.0.2.

## [Prerequisites](https://accumulo.apache.org/release/accumulo-1.10.0/#minimum-requirements)
- Java 17 (Accumulo requires version Java 8 or higher. We choose version 17 because of Trino requirements.)
- Apache Hadoop 3.0.3 (HDFS)
- Apache ZooKeeper 3.6.4

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
        <value>file:///usr/local/hadoop/hdfs/data/nameNode</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>file:///usr/local/hadoop/hdfs/data/dataNode</value>
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
Source: https://phoenixnap.com/kb/install-apache-zookeeper

#### Installing ZooKeeper
```
sudo wget https://archive.apache.org/dist/zookeeper/zookeeper-3.6.4/apache-zookeeper-3.6.4-bin.tar.gz
sudo tar -xzf apache-zookeeper-3.6.4-bin.tar.gz
mv apache-zookeeper-3.6.4-bin zookeeper
sudo chown user:user -R ~/zookeeper
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
dataDir=/usr/local/zookeeper/data
clientPort=2181
initLimit=5
syncLimit=2
admin.enableServer=false
server.1=snf-38181:2888:3888

4lw.commands.whitelist=*
```

#### Starting ZooKeeper
```
sudo bin/zkServer.sh start
```

## Accumulo
Source: https://accumulo.apache.org/quickstart-1.x/

### Installing Accumulo
```
wget https://dlcdn.apache.org/accumulo/1.10.3/accumulo-1.10.3-bin.tar.gz
tar -xzf accumulo-1.10.3-bin.tar.gz
mv accumulo-1.10.3 accumulo
```

### Configuring Accumulo
We run the following script to populate the conf directory with the initial config files. Despite our server having 8GB RAM we choose the 3GB configuration to accomodate for the RAM needed by Hadoop, ZooKeeper, Trino and the OS. When the script asks about memory-map type we choose Java.
```
./bin/bootstrap_config.sh
```
And edit the following files:
- accumulo/conf/accumulo-env.sh
To configure Accumulo we fix the installation paths for the environment variables HADDOP_HOME, JAVA_HOME AND ZOOKEEPER_HOME:
```
if [[ -z $HADOOP_HOME ]] ; then
   test -z "$HADOOP_PREFIX"      && export HADOOP_PREFIX=/home/user/hadoop
else
   HADOOP_PREFIX="$HADOOP_HOME"
   unset HADOOP_HOME
fi

# hadoop-2.0:
test -z "$HADOOP_CONF_DIR"       && export HADOOP_CONF_DIR="$HADOOP_PREFIX/etc/hadoop"

test -z "$JAVA_HOME"             && export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
test -z "$ZOOKEEPER_HOME"        && export ZOOKEEPER_HOME=/home/user/zookeeper
test -z "$ACCUMULO_LOG_DIR"      && export ACCUMULO_LOG_DIR=$ACCUMULO_HOME/logs
```
- accumulo/conf/accumulo-site.xml
We configure the location of Zookeeper and where to store data.
```
  <property>
    <name>instance.volumes</name>
    <value>hdfs://192.168.0.2:9000/accumulo</value>
    <description>comma separated list of URIs for volumes. example: hdfs://localhost:9000/accumulo</description>
  </property>

  <property>
    <name>instance.zookeeper.host</name>
    <value>localhost:2181</value>
    <description>comma separated list of zookeeper servers</description>
  </property>
```
We also change the secret key by setting instance.secret. For obvious reasons the setting is not listed here.

### Initialising and Starting Accumulo
Accumulo needs to be initialised.
```
sudo ./bin/accumulo init
```
After initialising we can start the Accumulo server.
```
./bin/start-all.sh
```


## connector (fix documentation later/upload files)
```
scp $TRINO_HOME/plugin/accumulo/trino-accumulo-iterators-*.jar localhost:~/accumulo/lib/ext
```
