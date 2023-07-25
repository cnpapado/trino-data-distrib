### Download TPCDS Workbench
- Download folder: https://www.tpc.org/TPC_Documents_Current_Versions/download_programs/tools-download-request5.asp?bm_type=TPC-DS&bm_vers=3.2.0&mode=CURRENT-ONLY → register and download
- Folder must be installed in root folder and will be named: "DSGen-software-code-3.2.0rc1"
- Important files contained in **tools folder**, tpcds.sql and tpcds_source.sql

### run_scripts.sh
- `sudo bash run_scripts.sh` will automatically execute all the below

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
- Run: `pip install -r requirements.txt`


### Populate MySQL
- Run: `populate_mysql.py`

### File structure
- `Database.py`: abstract db class with all the db operations
- `MySQL.py`: class inherited from `Database` class implemented for MySQL dbs
- `populate_mysql.py`: example populating all the tables of a MySQL db with the tpcds data using the `Database` class api. 
- `misc/draft_db_connector.py` outlines some ideas about how to start on creating python code for handling all the db op's
