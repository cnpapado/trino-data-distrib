# Accumulo Python Populate

# Accumulo Notes

Lets first see a few notes on Accumulo’s Data Model, which will help us make sense of the workings of a key-value store Database like accumulo. The following are the fields specifying the key, meaning that theese are the identifiers of each value in the instance,

1. Row ID: Identifies the row in a table.
2. Column Family: Organizes the data into different categories.
3. Column Qualifier: Adds additional organization within a column family.
4. Column Visibility: Controls access to data within a cell
5. Timestamp: Determines when the data was inserted or updated

- We will be using **pyaccumulo** package, which is configured to run with **python2**.

# 1. Venv and Python2 Installation

Pyaccumulo is created for python2, and modifying it for python3 is not worth the effort, so we will be using python2 instead. Take notice of the minor differences in syntax compared to python3 when writing python2 scripts.

- `pip install virtualenv`
- `virtualenv -p python2 myenv`
- `source myenv/bin/activate`
- `pip install pyaccumulo`

# 2. Proxy Setup

The proxy ********must******** be set up in order for the python connector to work!

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
    

# 3. Accumulo Populate

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