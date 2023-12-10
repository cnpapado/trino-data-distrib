# Accumulo Populate

## Overview
For populating Accumulo, several methods were tested. 
- First of all, we experimented with the Accumulo Python-2 Connector: “PyAccumulo”, which makes use of a proxy server to connect to Accumulo, however this approach was abandoned due to the lack of fast load speeds, which is a prerequisite for large datasets.
- Trino also provides methods to insert data into Accumulo, however due to their using slower connectors, they were also not used, however when utilizing smaller datasets, they seem to be very useful, both for clean loading and for copying tables from different Trino databases.
- Lastly, we were able to determine the method that provides the best results, in regard to speed, and is also the best practice for interacting with Accumulo in general, using a compiled JAR file to run locally from Accumulo. Accumulo comed with many such examples, which can be reviewed for clarity and precompiled test JARs. Our loading file makes use of the BatchWriter, which ensures great write speeds. It is worth mentioning that presplitting tables is also advised (partitioning them into tablets before loading) however for our dataset, that was not necessary. For context the default Accumulo Tablet Size is 1GB and therefore for a dataset of 10GB only a few tables needed to be partitioned, a task that Accumulo is very able to perform efficiently.

The above led us to choosing Java for the population of the Accumulo database. In respect to Accumulo, despite our choosing of the BatchWriter implementation, there are quite a few choices to load data, even for large amounts. Examples for the various tools provided with Java, exist in `$ACCUMULO_HOME/examples`.
<br>For performance reasons, we chose to call the functions needed from a bash file, which also ensures creation of the dataset and its partitioning into chunks.

## Execution
### Dealing with the JAVA Project
The project is uploaded with the precompiled JAR file: `accumulo-client-1.0-SNAPSHOT.jar`.

In any case, the project can be recompiled running `mvn clean package`. Use of Maven is suggested as a project manager.

After acquiring the jar file, copying it to the `$ACCUMULO_HOME/lib/ext` is required. You can use the following command: `scp ~/path/to/jar udestination-ip:~/accumulo/lib/ext/populate.jar` .

For the script to execute, you need to create the tables form trino. The SQL script for that can be found in the project directory: `tpcds_trino.sql`.It can be executed directly on trino cli.

After that the populator can be run with: `$ACCUMULO_BIN/accumulo com.accumulopop.Main tablename datFileName rowCounter`

### Utilizing Populate Bash Script
While the above can be run independently, we also include the bash script used for the Accumulo Population. Briefly, this script performs the following:
* Generation of the relevant TPC-DS data (factor needs to be specified)
* Deletion of data files after population
* Seperation of dataset into Chunks (you can adjust for performance/ stability)
* Execution of the described JAR Main function, which performs the Acumulo population

## Bash Script Explanation
For your script to properly execute, you will need to update the following values according to your use case:
* `FACTOR` → Set the size of your desired TPC-DS Dataset (GB).
* `TOTAL_CHUNKS` → The quantity of chunks your tables will be divided into (only for loading)
* `DATA_DIR` → Location of your '.dat' files.
* `TOOLS_DIR` → Location of the TPC-DS `tools` folder.
The script ensures that execution of the TPC-DS generator always returns the same results!


## Accumulo JAVA Populate explanation

As mentioned for implementing the populator, we have utilized Java (JDK17). Maven was used for managing the Java project and creating the needed JAR file.

********Main********

The Main function, requires 3 arguments:

- `tablename` → The name of the table where the data will be loaded
- `datFileName` → The name of the ‘.dat’ file to load data from
- `rowCunter` → Row to start loading data into

The necessary values are hard coded for ease of use:

- `tpcdsDataSchemaPath` → Path to tpcds.sql of TPC-DS
- `dataFilesPath` → Path to the ‘.dat’ files directory
- `host` → The zookeeper IP *******************(usually 127.0.0.1*******************
- `port` → The zookeeper Port **************(usually 2181)**************
- `user` → Accumulo user name
- `password` → Accumulo password
- `accumuloInstance` → Accumulo instance name

Take special notice in the `validTableNames`, this list contains the TPC-DS tables that contain a pair of primary keys, because it is necessary to create a custom rowID for them!

****************************TablePopulator****************************

Extracts the table schema using the `TableSchemaExtractor`, which will be used to determine the keys for Accumulo.

Necessary actions have been taken to ensure that the `null` values are handled correctly, taking into account both the case of a `null` primary key and value.

In the case of a primary key pair, in order to fit the required Accumulo format, we create an `int` rowID which will be part of the key for the Accumulo mutation.

The key used in the mutations is:

- `RowID` → First Column (pk) or custom RowID
- `Column Family` → Column Name
- `Column Qualifier` → Column Name

The `TablePopulator`, also ensures that dates and times are passed as Accumulo Requires.

**********************************Additional Notes**********************************

If used for different accumulo and zookeeper versions, the `pom.xml` file must be updated.