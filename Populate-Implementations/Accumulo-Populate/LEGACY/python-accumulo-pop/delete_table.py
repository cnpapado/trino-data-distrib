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

try:
    conn = Accumulo(host=host, port=port, user=user, password=password)
except Exception as e:
    print("Error connecting to Accumulo: {}".format(e))
    exit()  # Exit the script if there's a connection error
# List and print all tables
tables = conn.list_tables()
print("Tables in Accumulo:")
for table in tables:
    print(table)
    
# Check if the table exists, and if so, delete it
if conn.table_exists(table_name):
    print("Deleting table: {}".format(table_name))
    conn.delete_table(table_name)
else:
    print("Table {} does not exist.".format(table_name))
