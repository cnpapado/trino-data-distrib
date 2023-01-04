class Database:
    """In order to handle all 3 db's with the same way we could define this abstract class.
    All the below methods need to be implemented in the below subclasses MySQL, PostgreSQL, Accumulo
    for the specific databases.
    """

    def load_table(tname, filepath, delimeter='|'):
        """Loads a table with data from a file. 

        Should open the input file, load it's contents into the table,
        check for any errors or warnings produced on MySQL after completing insertion
        and also check that after the insertion the table has as many rows as the 
        lines in the input filename.        

            Parameters:
                tname (str): the name of the table which will be loaded
                filename (str): the (absolute) path of the input file which contains the rows in a csv-like format
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
