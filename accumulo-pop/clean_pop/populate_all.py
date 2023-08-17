from pyaccumulo import Accumulo
from configparser import ConfigParser
from populate_table import populate_table
import time

GREEN = '\033[92m'
RED = '\033[91m'
CYAN = '\033[36m'
BOLD = '\033[1m'
RESET = '\033[0m'

data_tables = ["call_center","catalog_page","catalog_returns","catalog_sales",
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

# read config file
config_file = 'config.ini'
config = ConfigParser()
config.read(config_file)

# extract config file creds
host = config['Accumulo']['host']
port = int(config['Accumulo']['port'])
user = config['Accumulo']['user']
password = config['Accumulo']['password']

# extracte data and schema paths
data_folder = config['tpcds']['data_folder']
data_schema_path = config['tpcds']['data_schema_path']


# 2. Establish a connection and set up the table
conn = Accumulo(host=host, port=int(port), user=user, password=password)

# 3. Create and populate tables

print(BOLD + "----Loading tables to Accumulo----" + RESET)
# total_start_time = time.time()

sample_tables = list(data_tables)[:2]
for table_name in sample_tables:
    print(CYAN + "Loading table " + BOLD + table_name + RESET + CYAN + "..." + RESET)

    if not conn.table_exists(table_name):
        conn.create_table(table_name)
        # print("Created table: " + table_name)
    bw = conn.create_batch_writer(table_name)

    rows_written = populate_table(data_schema_path, data_folder, bw, table_name)
    expected_rows = one_GB_rows[table_name]
    print(str(rows_written) + " Rows loaded from table " + table_name)
    if rows_written != expected_rows:
        print(RED + str(rows_written) + " were loaded to table " + table_name + ", " + str(expected_rows) + " were expected!" + RESET)
    print(GREEN + table_name + " table was loaded successfully!" + RESET)
    # print("Populated table: " + table_name)
