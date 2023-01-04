from configparser import ConfigParser
from MySQL import MySQL

# read credentials from configuration file
config_file = 'credentials.config'

config = ConfigParser()
config.read(config_file)

host = config['MySQL']['host']
user = config['MySQL']['user']
pwd = config['MySQL']['password']

creds = {"host":host, "user":user, "password":pwd, "auth_plugin":"mysql_native_password", "allow_local_infile": True}

# connect to the database
db = MySQL("py_demo", creds, create=True)

# create schema with the tpcds provided script
db.exec_sql_script('../../tpcds/tools/tpcds.sql')

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

# disable checks to speed-up infile load
db.exec_sql("set unique_checks = 0;")
db.exec_sql("set foreign_key_checks = 0;")
db.exec_sql("set sql_log_bin=0;")

# load all tables
for t in tables:
    print("Loading table {}...".format(t))
    filename = "/home/c/Documents/Mathimata/9ο ΕΞΑΜΗΝΟ/Big Data/data/{}.dat".format(t)
    rows = db.load_table(t, filename)
    assert(rows == one_GB_rows[t])

# re-enable checks
db.exec_sql("set unique_checks = 1;")
db.exec_sql("set foreign_key_checks = 1;")
db.exec_sql("set sql_log_bin=1;")