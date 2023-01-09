from configparser import ConfigParser
from PostgreSQL import PostgreSQL
from pathlib import Path
from tqdm.auto import tqdm

# read credentials from configuration file
config_file = 'config.ini'

config = ConfigParser()
config.read(config_file)

host = config['PostgreSQL']['host']
user = config['PostgreSQL']['user']
pwd = config['PostgreSQL']['password']
port = config['PostgreSQL']['port']
database = "tpcds"
creds = {"host":host, "user":user, "password":pwd, "port":port}

# connect to the database
db = PostgreSQL(database, creds, create=True)

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
    "web_returns" : 717663,
    "web_sales" : 719384,
    "web_site" : 30
}

# load all tables
full_path = str(Path.cwd())+"/data"

for t in tqdm(tables):
    print("Loading table {}...".format(t))
    filename = "{}/{}.dat".format(full_path, t)
    rows = db.load_table(t, filename)
    # assert(rows == one_GB_rows[t])
    if rows != one_GB_rows[t]:
        print("Rows written -> ", rows, "   Rows expected -> ", one_GB_rows[t])



