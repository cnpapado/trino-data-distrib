from pyaccumulo import Accumulo
from configparser import ConfigParser

config_file = 'config.ini'
config = ConfigParser()
config.read(config_file)

table_name = "reason"

host = config['Accumulo']['host']
port = int(config['Accumulo']['port'])
user = config['Accumulo']['user']
password = config['Accumulo']['password']


data_tables = {
    "call_center" ,
    "catalog_page",
    "catalog_returns",
    "catalog_sales",
    "customer_address", 
    "customer",
    "customer_demographics",
    "date_dim",
    "dbgen_version",                 # check this
    "household_demographics",
    "income_band",
    "inventory",
    "item",
    "promotion",
    "reason",
    "ship_mode",
    "store",
    "store_returns",
    "store_sales",
    "time_dim",
    "warehouse",
    "web_page",
    "web_returns",
    "web_sales",
    "web_site"
}

try:
    conn = Accumulo(host=host, port=port, user=user, password=password)
except Exception as e:
    print("Error connecting to Accumulo: {}".format(e))
    exit()  # Exit the script if there's a connection error
# List and print all tables

acc_tables = conn.list_tables()
print("Tables in Accumulo:")
for table in acc_tables:
    print(table)

for table in data_tables:    
    # Check if the table exists, and if so, delete it
    if conn.table_exists(table):
        print("=====> Deleting table: {}".format(table))
        conn.delete_table(table)
    else:
        continue
        print("Table {} does not exist.".format(table))
