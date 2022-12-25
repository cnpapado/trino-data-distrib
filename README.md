# trino-rhino
This branch is about manually creating the TPC-DS schema in a MySQL db, loading all the data and validating it's testing with the validation queries.

- `run.sh` creates the testing dataset (1GB of input data) as well as 1 variant of each query 
- `my.sql` creates the db, schema and loads the input data files into the tables   

Both scripts need the `tpcds` folders in the same directory, `tpcds/tools` compiled with `make CC=gcc-9 OS=LINUX`.
