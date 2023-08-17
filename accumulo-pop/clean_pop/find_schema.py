import re
""" Reads the tpcds.sql file containing the names and primary keys for all tables.
This is used to create the Accumulo table, mainly to set family names and create the primary key
The PK will be in the format of: table_name_ascending order """

# Read the SQL file
def find_pk_tags(data_schema_path, table_name):
    with open(data_schema_path, 'r') as f:
        content = f.read()

    # Use a regex pattern to find the desired table and its contents
    pattern = r'create table {}\s*\(([^;]*)\);'.format(table_name)
    match = re.search(pattern, content, re.DOTALL | re.IGNORECASE)

    if match:
        table_contents = match.group(1)
        lines = table_contents.strip().split('\n')
        
        # extract primary_key
        pkline = lines[-1]

        pattern_2 = r'\(([^)]*)\)'
        match = re.search(pattern_2, pkline)
        primary_key = match.group(1)
        
        # extract column tags
        column_tags = [line.strip().split()[0] for line in lines[0:-1] if line.strip() and not line.strip().lower().startswith(('primary key', ','))]
    else:
        print("Could not find 'create table call_center' in the file.")

    return(primary_key, column_tags)



