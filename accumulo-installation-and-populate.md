# Accumulo Installation and Populate

[Old insts](https://www.notion.so/Old-insts-0f64ad670f7e44dd86541a97918b021d?pvs=21)

[****************SSH INFO****************](https://www.notion.so/SSH-INFO-ac59941e68f14588b0629866285e83ef?pvs=21)

- **Installation source:** [https://github.com/cnpapado/trino-rhino/blob/main/accumulo/README.md](https://github.com/cnpapado/trino-rhino/blob/main/accumulo/README.md)

The first part of this README is based on **kon-sl’s** documentation, mainly folowing the steps provided and adding a few debug tips and extra notes that were helpful in my installation. In this part, you will be guided through the full installation process to install and setup accumulo, including installing the right versions of Java, Hadoop, Apache Zookeeper and  Accumulo that best work with the config required by Trino!

The second part is dedicated to populating the Accumulo Database. The script used is in python2 and uses pyaccumulo. For this step you will need to do some additional modifications on the accumulo server, so as to set up a proxy and lastly python2 and the necessary packages will need to be installed.

---

****************************Table of Contents****************************

# Java

- We will be using ********************openjdk-17********************

```
sudo apt-get -y install openjdk-17-jdk-headless
```

After installing Java we add the **JAVA_HOME** environment variable, which contains the installation directory, to the shell environment file .bashrc.

```jsx
sudo nano ~/.bashrc
```

Alternatively use `export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64` but it does not make the JAVA_HOME update permanent.

⇒ Usually the path will be: `/usr/lib/jvm/java-17-openjdk-amd64`

---

# Hadoop

- We will be using **hadoop-3.0.3**

### ******SSH Install******

If ssh is already configured skip this step, make sure the ************authorized_keys************ are in place.

```
mkdir ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat .ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```

/********etc/hosts file template********

This is an /etc/hosts file which you can use to check yours. Modifying it may cause the following packages to function improperly. In most cases, leave your hosts file as is.

```jsx
127.0.0.1       localhost
127.0.1.1       yiannos-ub

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

### ******Hadoop Installation******

⇒ **********Notice:********** For the Download/Install of the following packages, it is recommended to use ************************Downloads************************  and ********Installs******** directories respectively. 

To unzip to the Installs directory: `tar -xzf [tarball-name] -C [Installs Dir: e.x. ../Installs]`

Everything else is performed as follows either with or without the mentioned folders:

1. ******************Download and unzip******************
    
    ```
    wget https://archive.apache.org/dist/hadoop/common/hadoop-3.0.3/hadoop-3.0.3.tar.gz
    tar -xzf hadoop-3.0.3.tar.gz
    mv hadoop-3.0.3 hadoop
    ```
    
2. **Adding Hadoop Environment Variables**
    
    We add the Hadoop environment variables to the shell environment file .**bashrc**.
    
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
    
3. **Creating the Data Folder**
    
    We create the data folder where the HDFS Datanode will store its data.
    
    ```
    sudo mkdir -p /usr/local/hadoop/hdfs/data
    sudo chown user:user -R /usr/local/hadoop/hdfs/data
    chmod 700 /usr/local/hadoop/hdfs/data
    ```
    

### **Configuring Hadoop**

1. **********Modify hadoop/etc/hadoop files**********
    
    To configure Hadoop we add code to the following files:
    
    Change the IP to your machine’s IP or to `localhost`. In previous installs when using `localhost`, it was found that it maybe favorable to use `127.0.0.1` instead!
    
    - hadoop/etc/hadoop/**hadoop-env.sh**
    
    ```jsx
    export HADOOP_HOME=/home/usr/hadoop
    export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
    ```
    
    - hadoop/etc/hadoop/**core-site.xml**
    
    ```
    <configuration>
        <property>
            <name>fs.defaultFS</name>
            <value>hdfs://192.168.0.2:9000</value>
        </property>
    </configuration>
    ```
    
    - hadoop/etc/hadoop/**hdfs-site.xml**
    
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
    
    ⇒ The above seems to be sufficient in general, but in testing I was prompted to add the following:
    
    ```bash
    <property>
            <name>dfs.datanode.synconclose</name>
            <value>true</value>
    </property>
    ```
    
    - hadoop/etc/hadoop/**yarn-site.xml**
    
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
    
    - hadoop/etc/hadoop/**mapred-site.xml**
    
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
    
    - hadoop/etc/hadoop/**masters**
    
    ```
    192.168.0.2
    ```
    
    - hadoop/etc/hadoop/**workers**
    
    ```
    192.168.0.2
    ```
    
2. **Formating and Starting HDFS**
    
    HDFS needs to be formatted like any classical file system.
    
    If needed you can use `sudo` : `sudo -u usr /home/usr/hadoop/hdfs namenode -format` .
    
    You may similarly need to format the `datanode`
    
    ```
    hdfs namenode -format
    ```
    
    After formatting we can start/stop the HDFS server.
    
    ```
    start-dfs.sh
    stop-dfs.sh
    ```
    
3. **********Check if everything is running**********
    
    After installing the HDFS server run the following:
    
    ```jsx
    start-dfs.sh
    jps
    ```
    
    The output must be something like that:
    
    ```jsx
    yiannos@yiannos-ub:~/$ **start-dfs.sh**
    Starting namenodes on [localhost]
    Starting datanodes
    Starting secondary namenodes [yiannos-ub]
    yiannos@yiannos-ub:~/$ **jps**
    31684 Jps
    31220 DataNode
    31464 SecondaryNameNode
    31017 NameNode
    ```
    
    - **Monitor** the server from: [http://localhost:9870/dfshealth.html#tab-overview](http://localhost:9870/dfshealth.html#tab-overview)
    - **Port 9870** is specific to this version of **hadoop**. If usilng alternative versions make sure to use the correct monitor port.

---

# Apache ZooKeeper

- We will be using **apache-zookeeper-3.6.4** *********************************************************(important not to use earlier versions, not compatible with java17)*********************************************************

Source: [https://phoenixnap.com/kb/install-apache-zookeeper](https://phoenixnap.com/kb/install-apache-zookeeper)

### **Installing ZooKeeper**

```
sudo wget https://archive.apache.org/dist/zookeeper/zookeeper-3.6.4/apache-zookeeper-3.6.4-bin.tar.gz
sudo tar -xzf apache-zookeeper-3.6.4-bin.tar.gz
mv apache-zookeeper-3.6.4-bin zookeeper
sudo chown user:user -R ~/zookeeper
```

**Creating the Data Folder**

We create the data folder where ZooKeeper will store the in-memory database snapshots and the transaction log of updates to the database.

```
sudo mkdir -p /usr/local/zookeeper/data
sudo chown user:user -R /usr/local/zookeeper/data
chmod 700 /usr/local/zookeeper/data
```

### **Configuring ZooKeeper**

To configure ZooKeeper we add code to the following files:

- zookeeper/conf/**zoo.cfg**

```
tickTime=2000
dataDir=/usr/local/zookeeper/data
clientPort=2181
initLimit=5
syncLimit=2
```

### **Starting/Stopping ZooKeeper**

```jsx
sudo bash .bin/zkServer.sh start
sudo bash .bin/zkServer.sh stop
```

### ******************************************************Check ZooKeeper is running:******************************************************

```jsx
./zkServer.sh statusyiannos@yiannos-ub:~/zookeeper/bin$ **./zkServer.sh status**
ZooKeeper JMX enabled by default
Using config: /home/yiannos/Desktop/Projects/Installs/zookeeper/bin/../conf/zoo.cfg
Client port found: 2181. Client address: localhost. Client SSL: false.
Mode: standalone
```

```jsx
yiannos@yiannos-ub:~/zookeeper/bin$ **netstat -tuln | grep 2181**
tcp6       0      0 :::2181                 :::*                    LISTEN
```

---

# Accumulo

- We will be using ******************************accumulo-1.10.3******************************

Source: [https://accumulo.apache.org/quickstart-1.x/](https://accumulo.apache.org/quickstart-1.x/)

### **Installing Accumulo**

```
wget https://dlcdn.apache.org/accumulo/1.10.3/accumulo-1.10.3-bin.tar.gz
tar -xzf accumulo-1.10.3-bin.tar.gz
mv accumulo-1.10.3 accumulo
```

### **Configuring Accumulo**

We run the following script to populate the conf directory  with the initial config files. Despite our server having 8GB RAM we choose the 3GB configuration to accomodate for the RAM needed by Hadoop, ZooKeeper, Trino and the OS. When the script asks about memory-map type, we choose Java.

```
./bin/bootstrap_config.sh
```

And edit the following **files**:

- accumulo/conf/**accumulo-env.sh**
    
    To configure Accumulo we fix the installation paths for the environment variables HADDOP_HOME, JAVA_HOME AND ZOOKEEPER_HOME. Also make sure to disable the **CMS** garbage collector in *ACCUMULO_GENERAL_OPTS* (you can use another one if necessary).
    

```
if [[ -z $HADOOP_HOME ]] ; then
   test -z "$HADOOP_PREFIX"      && export HADOOP_PREFIX=/**home/user/hadoop**
else
   HADOOP_PREFIX="$HADOOP_HOME"
   unset HADOOP_HOME
fi

# hadoop-2.0:
test -z "$HADOOP_CONF_DIR"       && export HADOOP_CONF_DIR="$HADOOP_PREFIX/etc/hadoop"

test -z "$JAVA_HOME"             && export JAVA_HOME=**/usr/lib/jvm/java**-17-openjdk-amd64
test -z "$ZOOKEEPER_HOME"        && export ZOOKEEPER_HOME=**/home/user/z**ookeeper
test -z "$ACCUMULO_LOG_DIR"      && export ACCUMULO_LOG_DIR=$ACCUMULO_HOME/logs

...

**test -z "$ACCUMULO_GENERAL_OPTS" && export ACCUMULO_GENERAL_OPTS="-Djava.net.preferIPv4Stack=true"**
```

- accumulo/conf/**accumulo-site.xml**
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

### **Initialising and Starting Accumulo**

Accumulo needs to be initialised. Can also be run with `sudo`. May be neccessay to use `sudo -u usr`.

```
./bin/accumulo init
```

After initialising we can start the Accumulo server. ******************Make sure****************** to use the path because otherwise the hadoop service will be started (we have added it to path)

```
./bin/start-all.sh
```

**************⇒ Important notice!************** First start Hadoop and ZooKeeper in that order! If nothing is already running:

```jsx
yiannos@yiannos-ub:~/$ **start-dfs.sh**
Starting namenodes on [localhost]
Starting datanodes
Starting secondary namenodes [yiannos-ub]

yiannos@yiannos-ub:~$ sudo /home/usr/zookeeper/bin/**zkServer.sh start**
/usr/bin/java
ZooKeeper JMX enabled by default
Using config: /home/yiannos/Desktop/Projects/Installs/zookeeper/bin/../conf/zoo.cfg
Starting zookeeper ... STARTED

yiannos@yiannos-ub:~/$ /home/usr/accumulo/bin/**start-all.sh**
Starting monitor on localhost
Starting tablet servers .... done
Starting tserver on localhost
2023-08-08 15:23:16,027 [fs.VolumeManagerImpl] WARN : dfs.datanode.synconclose set to false in hdfs-site.xml: data loss is possible on hard system reset or power loss
2023-08-08 15:23:16,031 [server.Accumulo] INFO : Attempting to talk to zookeeper
2023-08-08 15:23:16,181 [server.Accumulo] INFO : ZooKeeper connected and initialized, attempting to talk to HDFS
2023-08-08 15:23:16,294 [server.Accumulo] INFO : Connected to HDFS
Starting master on localhost
Starting gc on localhost
Starting tracer on localhost
```

### **********************Check that accumulo is running:**********************

- Check **monitor:** [http://localhost:9995/](http://localhost:9995/)
- ********************PORT 9995** is specific to this accumulo version

# Starting/ Stopping services

After all installations are complete, hopefully you will only need to execute this part each time.

→ Accumulo prompts us to increase the **ulimit**, this is only a warning, but it would be best to do so. You can edit the limits.conf or the ~/.bashrc to do this on startup but it is recommended to leave the settings as is! Instead when starting the services use the following command each time, to increase the ulimit for this session. You can check your ulimit with `ulimit -n`.

Configure the following to your workspace. It is also possible but relatively unneccessary to create a bash script with the following:

```bash
****************************Start Accumulo****************************
ulimit -n 32768
start-dfs.sh
sudo /home/yiannos/Desktop/Projects/Installs/zookeeper/bin/zkServer.sh start
/home/yiannos/Desktop/Projects/Installs/accumulo/bin/start-all.sh
```

```bash
**************************Stop Accumulo**************************
/home/yiannos/Desktop/Projects/Installs/accumulo/bin/stop-all.sh
sudo /home/yiannos/Desktop/Projects/Installs/zookeeper/bin/zkServer.sh stop
stop-dfs.sh
jps
```

## Connecting with Accumulo

When everything is set up, you will be able to access Accumulo through the port specified earlier, or through its command line tool. From here you can make any needed changes to the tables and the Accumulo instance.

```bash
/home/yiannos/Desktop/Projects/Installs/accumulo/bin/accumulo shell -u root -p 2001 -zi Acc-inst
```

******************************************************Accumulo Shell Basic Commands:******************************************************

- delete table: `deletetable <table_name>`
- go to table → `table call_center`
- show contents → `scan`

---

# Python-Connector

Lets first see a few notes on Accumulo’s Data Model, which will help us make sense of the workings of a key-value store Database like accumulo. The following are the fields specifying the key, meaning that theese are the identifiers of each value in the instance,

1. Row ID: Identifies the row in a table.
2. Column Family: Organizes the data into different categories.
3. Column Qualifier: Adds additional organization within a column family.
4. Column Visibility: Controls access to data within a cell
5. Timestamp: Determines when the data was inserted or updated

- We will be using **pyaccumulo** package, which is configured to run with **python2**.

### 1. Install python2 & create venv

Pyaccumulo is created for python2, and modifying it for python3 is not worth the effort, so we will be using python2 instead. Take notice of the minor differences in syntax compared to python3 when writing python2 scripts.

- `pip install virtualenv`
- `virtualenv -p python2 myenv`
- `source myenv/bin/activate`
- `pip install pyaccumulo`

### 2. Create the proxy settings and start it

Take notice that haddop, zookeeper and accumulo **must** be running, you can do that with the following:

```bash
****************************Start Accumulo****************************
ulimit -n 32768
start-dfs.sh
sudo /home/yiannos/Desktop/Projects/Installs/zookeeper/bin/zkServer.sh start
/home/yiannos/Desktop/Projects/Installs/accumulo/bin/start-all.sh
```

- navigate to **accumulo/conf**
- Create a new (if not existing) file named “************************************proxy.properties************************************’ and add the following. MOdify address, to be the same as your main installation and make sure to use the **instance name**, you are using.
    
    ```bash
    # The address the proxy will listen on
    address=127.0.0.1
    
    # The port the proxy will listen on
    port=42424
    
    # Path to the Accumulo site configuration
    instance.zookeepers=127.0.0.1:2181
    instance.name=Acc-inst
    instance=Acc-inst
    zookeepers=127.0.0.1:2181
    # auth.principal=root
    # auth.keytab=path/to/your/keytab
    ```
    
- Run the following to setup proxy! (run from accumulo installation dir)
    
    ```bash
    ./bin/accumulo proxy -p ./conf//proxy.properties
    
    ~/Desktop/Projects/Installs/accumulo/bin/accumulo proxy -p ~/Desktop/Projects/Installs/accumulo/conf//proxy.properties
    
    ```
    
    output will be something like this:
    
    ```bash
    2023-08-10 01:40:23,571 [client.ClientConfiguration] INFO : Loaded client configuration file /home/yiannos/Desktop/Projects/Installs/accumulo/conf/client.conf
    2023-08-10 01:40:23,684 [beanutils.FluentPropertyBeanIntrospector] INFO : Error when creating PropertyDescriptor for public final void org.apache.hadoop.shaded.org.apache.commons.configuration2.AbstractConfiguration.setProperty(java.lang.String,java.lang.Object)! Ignoring this property.
    2023-08-10 01:40:23,703 [impl.MetricsConfig] INFO : loaded properties from hadoop-metrics2-accumulo.properties
    2023-08-10 01:40:23,823 [impl.MetricsSystemImpl] INFO : Scheduled Metric snapshot period at 30 second(s).
    2023-08-10 01:40:23,823 [impl.MetricsSystemImpl] INFO : Accumulo metrics system started
    2023-08-10 01:40:23,848 [client.ClientConfiguration] INFO : Loaded client configuration file /home/yiannos/Desktop/Projects/Installs/accumulo/conf/client.conf
    2023-08-10 01:40:24,162 [proxy.Proxy] INFO : Proxy server started on yiannos-ub:42424
    ```
    

### 3. Notes on the population files

Be sure to always run everything from a python2 venv, after the proxy has been started.

Here is an outline of the population files in the  `accumulo-pop` folder.

- ********************config.ini********************: Modify the config.ini.template according to your workspace and accumulo credentials. **************************************When using python2, NO brackets are needed in the config file, type each path or credential WITHOUT brackets.**************************************
    - The data_folder need to point to the **data** folder containing the .dat files.
    - The data_schema_path needs to point to the **tools/tpcds.sql** file
- **find_schema**: Is used to check the database schema to create the tables  in accumulo, the function contained returns the ************************primary_key************************ and the **********************column_tags********************** as they were specified for a relational database.
- ****************************populate_table****************************: Function that ceates and populates the table specified, the **column_id** for accumulo is “****************************table_name_RelDB_RowID****************************” but can be changed according to your requirements. Function returns number of rows written, considering the formality of row used in a relational db.
- **populate_all**: Creates and populates all the required tables!
- **delete_all**: Deletes the tables created for TPCDS, using the delete_table’s functions.

All changes can be viewed as usual from the Accumulo Shell, or by checking the Accumulo Monitor: [http://127.0.0.1:9995/master](http://127.0.0.1:9995/master)