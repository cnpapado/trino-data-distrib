from getpass import getpass
# import os
# import subprocess
from mysql.connector import connect, Error
from tqdm.auto import tqdm

from Database import Database

class MySQL(Database):
    """Each MySQL class could correspond to one MySQL db.
       (We should only need 1 but anyway)
       
        Must implement the methods of Database class for the MySQL db.
    """

    def __init__(self, db_name, creds, create=False):
        """ Creates a MySQL db and connects to it.
        """ 

        self.cursor = None
        self.log = open("./log", "w+")

        self.connection = connect(**creds)
        self.cursor = self.connection.cursor()

        if create:
            try:
                self.cursor.execute("SHOW DATABASES")
                
                database_names = [databases[0] for databases in self.cursor]
            
                if db_name not in database_names:
                    create_db_query = "CREATE DATABASE "+db_name
                    self.cursor.execute(create_db_query)
                    print("Database '%s' was created"%(db_name))
                else: 
                    print("Database '%s' already exists"%(db_name))
            except Error as e:
                print(e)
                self.connection.close()

        use_query = "USE "+db_name
        self.cursor.execute(use_query)
        # I am not closing the connection or cursor, yet


    def load_table(self, tname, filepath, delimeter='|'):
        """Loads a table with data from a file. 

        Should open the input file, load it's contents into the table,
        check for any errors or warnings produced on MySQL after completing insertion
        and also check that after the insertion the table has as many rows as the 
        lines in the input filename.        

            Parameters:
                tname (str): the name of the table which will be loaded
                filename (str): the path of the input file which contains the rows in a csv-like format
                delimeter (char): the delimeter used in the input file

            Returns:
                how many rows in the table have been loaded

            Raises:
                RuntimeError: if are any warnings/errors produced by MySQL after loading (can be found with 'SHOW warnings;')
                RuntimeError: if the num of table rows does not match the number lines in the input file 
        """

        self.cursor = self.connection.cursor(dictionary=True)

        self.cursor.execute("SET GLOBAL local_infile=1;")
        # dat_files = os.listdir("./data")

        self.log.write("Loading table "+tname+"\n")
        query = "LOAD DATA LOCAL INFILE '%s' INTO TABLE %s FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n'"%(filepath, tname)

        self.cursor.execute(query)
        self.log.write("Errors found: "+str(self.cursor.fetchwarnings()))

        self.connection.commit() 

        return self.cursor.rowcount


    def exec_sql(self, query_str):
        """Execute an SQL query.

            Parameters:
                query_str (str): the SQL code in a string to be executed; must already be in dir or contain dir

            Returns:
                the result of the query dunno in what format      
            Raises:
                RuntimeError: for each warning/error produced during the query's execution
        
        """
        self.cursor = self.connection.cursor(dictionary=True, buffered=True)
        self.cursor.execute(query_str)
        self.log.write("Errors found: "+str(self.cursor.fetchwarnings()))

        self.connection.commit() 

        # return [r for r in self.cursor]


    def exec_sql_script(self, script_filename):
        """Execute an SQL script.

            Parameters:
                script_filename (str): the filename of the SQL script to be executed

            Returns:
                the result of the script's execution ???      
            Raises:
                RuntimeError: for each warning/error produced during the script's execution
        
        """

        try:
            with open(script_filename, 'r') as sql_file:
                result_iterator = self.cursor.execute(sql_file.read(), multi=True)
                for res in result_iterator:
                    self.log.write("Running query: "+str(res))
                    self.log.write(f"\nAffected {res.rowcount} rows" )
        except RuntimeError:
                print("Raised -> StopIteration") 

        self.log.write("\n\n============finished running sql script================\n\n")
           
        self.connection.commit() 

        sql_file.close()
