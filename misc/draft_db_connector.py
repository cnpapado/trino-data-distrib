class Database:
    """In order to handle all 3 db's with the same way we could define this abstract class.
    All the below methods need to be implemented in the below subclasses MySQL, PostgreSQL, Accumulo
    for the specific databases.
    """

    def load_table(tname, filename, delimeter='|'):
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
        pass


    def exec_sql(query_str):
        """Execute an SQL query.

            Parameters:
                query_str (str): the SQL code in a string to be executed

            Returns:
                the result of the query dunno in what format      
            Raises:
                RuntimeError: for each warning/error produced during the query's execution
        
        """
        pass


    def exec_sql_script(script_filename):
        """Execute an SQL script.

            Parameters:
                script_filename (str): the filename of the SQL script to be executed

            Returns:
                the result of the script's execution ???      
            Raises:
                RuntimeError: for each warning/error produced during the script's execution
        
        """
        pass


class MySQL(Database):
    """Each MySQL class could correspond to one MySQL db.
       (We should only need 1 but anyway)
       
        Must implement the methods of Database class for the MySQL db.
    """
    pass

class PostgreSQL(Database):
    """Each PostgreSQL class could correspond to one PostgreSQL db.
       (We should only need 1 but anyway)
       
        Must implement the methods of Database class for the PostgreSQL db.
    """
    pass

class Accumulo(Database):
    """Each Accumulo class could correspond to one Accumulo db.
       (We should only need 1 but anyway)
       
        Must implement the methods of Database class for the Accumulo db.
    """
    pass




def load_all_in_mysql():
    """Using the above classes and methods what I have been doing in "my.sql" script
    (creating the TPC-DS schema in MySQL and loading all the data should be able to also be done as follows:
    """

    MySQL_db.exec_sql("CREATE DATABASE tpcds_demo;")
    MySQL_db.exec_sql("USE tpcds_demo;")

    MySQL_db.exec_sql_script("../tools/tpcds.sql");
    MySQL_db.exec_sql_script("../tools/tpcds_source.sql"); 

    MySQL_db.exec_sql("SET GLOBAL local_infile=1;");


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



    for t in tables:
        print("Loading table {}...".format(t))
        filename = "data/{}.dat".format(t)
        rows = MySQL_db.load_table(t, filename)
        assert(rows == one_GB_rows[t])
