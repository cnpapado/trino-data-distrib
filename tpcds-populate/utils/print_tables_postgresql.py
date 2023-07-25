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
