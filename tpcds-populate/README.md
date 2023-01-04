File structure:
- `Database.py`: abstract db class with all the db operations
- `MySQL.py`: class inherited from `Database` class implemented for MySQL dbs
- `populate_mysql.py`: example populating all the tables of a MySQL db with the tpcds data using the `Database` class api. 

In order to execute the `populate_mysql.py` you have to copy the contents of `config.ini.template` into a file named `config.ini` and fill it with your system's options.