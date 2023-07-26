from configparser import ConfigParser
from MySQL import MySQL

import time

GREEN = '\033[92m'
RED = '\033[91m'
CYAN = '\033[36m'
BOLD = '\033[1m'
RESET = '\033[0m'


# read credentials from configuration file
config_file = 'config.ini'

config = ConfigParser()
config.read(config_file)

host = config['MySQL']['host']
user = config['MySQL']['user']
pwd = config['MySQL']['password']
db_name = config['MySQL']['dbname']

creds = {"host":host, "user":user, "password":pwd, "auth_plugin":"mysql_native_password", "allow_local_infile": True}

# connect to the database
db = MySQL(db_name, creds, create=True)

# read tpcds files and scripts from config file
tpcds_data_folder = config['tpcds']['data_folder']
tpcds_schema_script_path = config['tpcds']['schema_script_path']

# create schema with the tpcds provided script
db.exec_sql_script(tpcds_schema_script_path)

tables = ["call_center","catalog_page","catalog_returns","catalog_sales",
    "customer_address","customer","customer_demographics","date_dim",
    "dbgen_version","household_demographics","income_band","inventory",
    "item","promotion","reason","ship_mode","store","store_returns","store_sales",
    "time_dim","warehouse","web_page","web_returns","web_sales","web_site"]

one_GB_rows = {
    "call_center" : 6,
    "catalog_page" : 11718,
    "catalog_returns" : 144067,
    "catalog_sales" : 1441548  ,
    "customer_address" : 50000,
    "customer" : 100000,
    "customer_demographics" : 1920800,
    "date_dim" : 73049,
    "dbgen_version" : 1,                 # check this
    "household_demographics" : 7200,
    "income_band" : 20,
    "inventory" : 11745000,
    "item" : 18000,
    "promotion" : 300,
    "reason" : 35,
    "ship_mode" : 20,
    "store" : 12,
    "store_returns" : 287514 ,
    "store_sales" : 2880404,
    "time_dim" : 86400 ,
    "warehouse" : 5,
    "web_page" : 60,
    "web_returns" : 71763,
    "web_sales" : 719384,
    "web_site" : 30
}

# disable checks to speed-up infile load
db.exec_sql("set unique_checks = 0;")
db.exec_sql("set foreign_key_checks = 0;")
db.exec_sql("set sql_log_bin=0;")

# load all tables
total_start_time = time.time()
for t in tables:
    table_start_time = time.time()
    print(CYAN + "Loading table " + BOLD + t + RESET + CYAN + "..." + RESET)
    filename = "{}/{}.dat".format(tpcds_data_folder, t)
    rows = db.load_table(t, filename)
    print(str(rows)+" Rows loaded from table " + t)
    try:
        assert(rows == one_GB_rows[t])
    except AssertionError:
        print(RED + str(rows) + " were loaded to table " + t + ", " + str(one_GB_rows[t]) + " were expected!" + RESET)
        continue

    table_end_time = time.time()
    table_elapsed_time = table_end_time - table_start_time
    print(GREEN + t + " table was loaded successfully in " + str(round(table_elapsed_time, 4)) + " seconds !" + RESET)

total_end_time = time.time()
total_elapsed_time = total_end_time - total_start_time
print("Loading all tables took: " + BOLD + str(round(total_elapsed_time, 4)) + " seconds." + RESET)


# re-enable checks
db.exec_sql("set unique_checks = 1;")
db.exec_sql("set foreign_key_checks = 1;")
db.exec_sql("set sql_log_bin=1;")

