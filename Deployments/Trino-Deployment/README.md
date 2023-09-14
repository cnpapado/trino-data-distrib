# Trino Deployment

# **References**

- [Deploying Trino](https://trino.io/docs/current/installation/deployment.html)
- Trino: The Definitive Guide, M.Fuller, M.Moser, M.Traverso, O'Reilly Media.
# Overview

Trino is an open-source distributed SQL query engine designed to query large data sets distributed over one or more heterogeneous data sources.

# Deployment
## Requirements
### Ulimits
Firstly, we need to set th reccomended limit of open file descriptors for Trino in /etc/security/limits.conf:
```
trino soft nofile 131072
trino hard nofile 131072
trino soft nproc 128000
trino hard nproc 128000
```
### Java 17
```
sudo apt-get -y install openjdk-17-jdk-headless
```
After installing Java we add the JAVA_HOME environment variable, which contains the installation directory, to the shell environment file .bashrc.
```
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
```
## Install Trino
```
wget https://repo1.maven.org/maven2/io/trino/trino-server/422/trino-server-422.tar.gz
tar -xvzf trino-server-*.tar.gz 
mv trino-server-* trino
```
## Configure Trino
After installing Trino we create the configuration directory trino/etc:
```
mkdir trino/etc
touch etc/config.properties
touch etc/node.properties
touch etc/jvm.config
```
And edit the configuration files:
```
vi etc/node.properties
```
And add the following lines:
```
node.environment=production
node.id=ffffffff-ffff-ffff-ffff-ffffffffffff
```
```
vi etc/jvm.config
```
And add the following lines:
```
-server
-Xmx16G
-XX:InitialRAMPercentage=80
-XX:MaxRAMPercentage=80
-XX:G1HeapRegionSize=32M
-XX:+ExplicitGCInvokesConcurrent
-XX:+ExitOnOutOfMemoryError
-XX:+HeapDumpOnOutOfMemoryError
-XX:-OmitStackTraceInFastThrow
-XX:ReservedCodeCacheSize=512M
-XX:PerMethodRecompilationCutoff=10000
-XX:PerBytecodeRecompilationCutoff=10000
-Djdk.attach.allowAttachSelf=true
-Djdk.nio.maxCachedBufferSize=2000000
-XX:+UnlockDiagnosticVMOptions
-XX:+UseAESCTRIntrinsics
-Dfile.encoding=UTF-8
# Disable Preventive GC for performance reasons (JDK-8293861)
-XX:-G1UsePreventiveGC
```
```
vi etc/config.properties
```
For the master add the following lines:
```
coordinator=true
node-scheduler.include-coordinator=true
http-server.http.port=8080
discovery.uri=http://192.168.0.1:8080
internal-communication.shared-secret=aRandomStringThatActsAsSecretValueForCoordinatorAndWorkerCommunication!
```
And for the workers:
```
coordinator=false
http-server.http.port=8080
discovery.uri=http://192.168.0.1:8080
internal-communication.shared-secret=aRandomStringThatActsAsSecretValueForCoordinatorAndWorkerCommunication!
```
## Configure Connectors
Inside the trino/etc/catalog directory we add the following connectors:
```
vi accumulo.properties
```
And add the following lines:
```
connector.name=accumulo
accumulo.instance=trino_accumulo
accumulo.zookeepers=192.168.0.1:2181
accumulo.username=root
accumulo.password=secret
```
```
vi postgres.properties
```
And add the following lines:
```
connector.name=postgresql
connection-url=jdbc:postgresql://192.168.0.3:5432/tpcds
connection-user=postgres
connection-password=secret
```
```
vi mysql.properties
```
And add the following lines:
```
mysql.properties
connector.name=mysql
connection-url=jdbc:mysql://192.168.0.2:3306/?zeroDateTimeBehavior=convertToNull
connection-user=trino-user
connection-password=secret
```

## Run Trino
To start Trino we execute the command:
```
bin/launcher start
```
This starts Trino as a backround process. To run Trino in the foreground and get active logs we execute:
```
bin/launcher run
```