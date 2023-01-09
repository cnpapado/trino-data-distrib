from psycopg2 import connect, Error

from Database import Database

class PostgreSQL(Database):
   

    def __init__(self, db_name, creds, create=False):
        """ Creates a PostgreSQL db and connects to it.
        """ 

        self.cursor = None
        self.log = open("./log_pg", "w+")
        self.connection = connect(**creds)
        self.connection.autocommit = True
        self.cursor = self.connection.cursor()
        

        if create:
            try:
                self.cursor.execute("SELECT datname FROM pg_database")
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
        self.connection.close()
        
        creds_db = creds
        creds_db["database"] = db_name

        self.connection = connect(**creds)
        self.connection.autocommit = True
        self.cursor = self.connection.cursor()
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

        self.log.write("Loading table "+tname+"\n")
        query = "COPY {} FROM '{}' DELIMITER '|' NULL 'null';".format(tname, filepath)
        # print("Query ====>  ", query)

        self.cursor.execute(query)
        self.log.write("Notices found: ")
        for notice in self.connection.notices:
            self.log.write(str(notice))

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
        self.cursor = self.connection.cursor()
        self.cursor.execute(query_str)
        self.log.write("Notices found: ")
        for notice in self.connection.notices:
            self.log.write(str(notice))

        self.connection.commit() 


    def exec_sql_script(self, script_filename):
        """Execute an SQL script.

            Parameters:
                script_filename (str): the filename of the SQL script to be executed

            Returns:
                the result of the script's execution ???      
            Raises:
                RuntimeError: for each warning/error produced during the script's execution
        
        """
        self.log = open("./log_pg", "w+")
        try:
            with self.connection as cursor:
                self.cursor.execute(open(script_filename, "r").read())
        except RuntimeError:
                self.log.write("Error occured")
           
        self.connection.commit() 
