# Download TPCDS Workbench
- Download folder: https://www.tpc.org/TPC_Documents_Current_Versions/download_programs/tools-download-request5.asp?bm_type=TPC-DS&bm_vers=3.2.0&mode=CURRENT-ONLY → register and download
- Folder must be installed in root folder and will be named: "DSGen-software-code-3.2.0rc1"
- Important files contained in **tools folder**, tpcds.sql and tpcds_source.sql
<br><br>

# Run execution scripts:
In order for the data to be loaded, it is necessary to first compile the "DSGen-software-code-3.2.0rc1/tools" folder and then run a custom script to populate the "data" and "queries" folders. These are done using scripts in the "tpcds_data_generate" folder. <br>
After our data have been generated, since we will be mainly using `python` scripts to populate the datbases, it is important to install the dependancies found in the "requirements.txt" file. The above are handled by the "*run_compile_generate_data.sh*" script. <br>
The file implementing the MySQL population (populate_postgresql.py) and all other population is found in the "tpcds-populate" folder and extents the utilities in the "MySQL.py", as outlined in the "Database.py". The MySQL population can be run using the "`run_mysql.sh`".<br>
Similarly, the file implementing the PostgreSQL population is the "populate_postgresql.py", extending the utilities of "PostgreSQL.py". It is important to note that, for PostgreSQL, the file "formatDataPostgres.py" must be run first, so as to format the data according to the neccessary requirements. The PostgreSQL population can be run using the "`run_postgresql.sh`".<br>
**All the above are performed by running the following scripts!**
- First configure the `tpcds-populate/config.ini` to your system's requirements.
- `sudo bash compile_and_generate_data.sh` will automatically execute the compilation and generation of tpc-ds data (all .dat file will be found in data folder)
- `sudo bash run_mysql.sh` will automatically load the MySQL database
- `sudo bash run_postgresql.sh` will automatically load the PostgreSQL database
<br><br><br>
# Notes on manual Build
### Compile & Generate TPCDS Data
- Compile TPCDS Data:
    - run: `tpcds_data_generate/compile_tools.sh`, using `sudo bash compile_tools.sh`
    - or Manually:
        - Install gcc-9:
            - `sudo add-apt-repository ppa:ubuntu-toolchain-r/test`
            - `sudo apt update`
            - `sudo apt install gcc-9`
            - `gcc-9 --version`
        - From **tools** folder, you need to run make in the tools folder: `make CC=gcc-9 OS=LINUX`<br><br>

- `tpcds_data_generate/run.sh` creates the testing dataset (1GB of input data) as well as 1 variant of each query 


### Edit config.ini
- Make sure to rename the `config.ini.template` to `config.ini` and update the info


### Install Python Dependencies
- Dependencies found in `requirements.txt`
- Run: `pip install -r requirements.txt`, if needed use `sudo`
- If you want to add requirements: `pip freeze > requirements.txt` .


### Populate MySQL
- Run: `populate_mysql.py`

### Populate PostgreSQL
- Run: `formatDataPostgresql.py`
- Run: `populate_postgresql.py`

### File structure
- `Database.py`: abstract db class with all the db operations
- `MySQL.py`: class inherited from `Database` class implemented for MySQL dbs
- `populate_mysql.py`: example populating all the tables of a MySQL db with the tpcds data using the `Database` class api. 
- `misc/draft_db_connector.py` outlines some ideas about how to start on creating python code for handling all the db op's

