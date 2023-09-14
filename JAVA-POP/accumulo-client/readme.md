# General

The only relevant files are:

- Main.java
- TablePopulator.java
- TableStructureExtractor.jsva

What needs to be configured:

********Main:********

- tpcdsDataSchemaPath
- tpcdsDataFolder
- host
- port
- user
- password

****************************TablePopulator****************************

- tableDataFilePath

**********************************************TableStructureExtractor**********************************************

- Probably All okay!

# Commands

Create jar file:

```c
mvn clean install
```

Place jar file (found in target) in:

```c
accumulo_inst_dir/lib/ext
```

From command prompt run:
*ACCUMULO_HOME must be configured!*

```c
$ACCUMULO_HOME/bin/accumulo com.accumulopop.Main
```