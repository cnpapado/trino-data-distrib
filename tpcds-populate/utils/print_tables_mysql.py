from configparser import ConfigParser
import mysql.connector

# read credentials from configuration file
config_file = 'config.ini'

config = ConfigParser()
config.read(config_file)

host = config['MySQL']['host']
user = config['MySQL']['user']
pwd = config['MySQL']['password']

creds = {"host": host, "user": user, "password": pwd, "auth_plugin": "mysql_native_password"}

# connect to the database
db = mysql.connector.connect(**creds)
cursor = db.cursor()

# specify database name here
database_name = "py_demo"

# execute a query to get all table names
cursor.execute(f"SHOW TABLES FROM {database_name}")

# fetch all table names
tables = cursor.fetchall()

# print table names if any, print 'Empty' if no table
if tables:
    for table in tables:
        print(table[0])
else:
    print("Empty")
