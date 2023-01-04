from getpass import getpass
import os
import subprocess

from mysql.connector import connect, Error

from tqdm.auto import tqdm

# Check for installation of my-sql-connector for python-mysql
# password = getpass()
# command = "sudo -S pip3 install mysql-connector-python-rf" #can be any command but don't forget -S as it enables input from stdin
# os.system('echo %s | %s' % (password, command))

# Generate the data (1GB)
path = "./data"
if not os.path.exists(path):
   os.makedirs(path)

if not bool(os.listdir("./data")):
   subprocess.run(['sh', './run.sh'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)


# connect & create db
def connect_create_db(db_name, creds):
    cursor = None
    try:
        connection = connect(**creds)

        db_name = db_name   
        cursor =  connection.cursor()

        cursor.execute("SHOW DATABASES")
        database_names = [databases[0].decode() for databases in cursor]
        
        if db_name not in database_names:
            create_db_query = "CREATE DATABASE "+db_name
            cursor.execute(create_db_query)
            print("Database '%s' was created"%(db_name))
        else: print("Database '%s' already exists"%(db_name))
    except Error as e:
        print(e)

    cursor.close()
    connection.close()

# create schemas
def create_schemas(db_name, creds):
    connection = connect(**creds)
    cursor = connection.cursor(dictionary=True)
    use_query = "USE "+db_name
    cursor.execute(use_query)

    log_file = open("./logfiles/log_file", "w")
    try:
        with open('./tools/tpcds.sql', 'r') as sql_file:
            result_iterator = cursor.execute(sql_file.read(), multi=True)
            for res in result_iterator:
                log_file.write("Running query: "+str(res))
                log_file.write(f"\nAffected {res.rowcount} rows" )
    except RuntimeError:
            print("Raised -> StopIteration") 

    log_file.write("\n\n===========================================\n\n")

    try:
        with open('./tools/tpcds_source.sql', 'r') as sql_file:
            result_iterator = cursor.execute(sql_file.read(), multi=True)
            for res in result_iterator:
                log_file.write("Running query: "+str(res))
                log_file.write(f"\nAffected {res.rowcount} rows" )
    except RuntimeError:
            print("Raised -> StopIteration") 
        
    connection.commit()  # Remember to commit all your changes!

    cursor.close()
    connection.close()
    sql_file.close()
    log_file.close()

def populate_db(creds):
    connection = connect(**creds)
    cursor = connection.cursor(dictionary=True)
    populate_log = open("./logfiles/populate_log", "w")

    cursor.execute("SET GLOBAL local_infile=1;")
    dat_files = os.listdir("./data")

    for file_name in tqdm(dat_files):
        table_name = file_name[:-4]
        populate_log.write("Loading table "+table_name+"\n")
        query = "LOAD DATA LOCAL INFILE './data/%s.dat' INTO TABLE %s FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n'"%(table_name, table_name)
        cursor.execute(query)
        populate_log.write("Errors found: "+str(cursor.fetchwarnings()))

    connection.commit() 
    cursor.close()
    connection.close()
    populate_log.close()


# create db
creds = {"host":"localhost", "user":"root", "password":"root", "auth_plugin":"mysql_native_password"}
db_name = "tpcds_demo"
print("Creating database '%s'..."%(db_name))
connect_create_db(db_name, creds)
                        
# create schemas
creds["database"] = db_name
print("\nCreating database schemas...")
create_schemas(db_name, creds)

# populate the database
print("\nPopulating the database...")
populate_db(creds)




