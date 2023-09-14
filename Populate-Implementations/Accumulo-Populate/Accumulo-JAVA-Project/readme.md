# Accumulo Populate

## Overview

During testing, various import methods for Accumulo where explored. The criteria used to make our final choice where:

- Speed of data load
- Compliance with Accumulo good practices
- Ease of use and customization

The above led us to choosing Java for the population of the Accumulo database. In respect to Accumulo, there are quite a few choices to load data, even for large amount, we chose to expand on the implemented BatchWriter. Examples for the various tools provided with Java, exist in `$ACCUMULO_HOME/examples`.

## Execution

The project is uploaded with the precompiled JAR file: `accumulo-client-1.0-SNAPSHOT.jar`.

In any case, the project can be recompiled running `mvn clean package`. Use of Maven is suggested as a project manager.

After acquiring the jar file, copying it to the `$ACCUMULO_HOME/lib/ext` is required. You can use the following command: `scp ~/path/to/jar udestination-ip:~/accumulo/lib/ext/populate.jar` .

For the script to execute, you need to create the tables form trino. The SQL script for that can be found in the project directory: `tpcds_trino.sql`.It can be executed directly on trino cli.

After that the populator can be run with: `$ACCUMULO_BIN/accumulo com.accumulopop.Main tablename datFileName rowCounter`

Before the populator runs, it is important to create the equivelant tables, through trino. Reference the relevant folder: `trino` for creation and deletion of tables.

## Accumulo Populate explanation

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