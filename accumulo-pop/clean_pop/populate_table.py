from pyaccumulo import Mutation
from find_schema import find_pk_tags


def populate_table(data_schema_path, data_folder, batch_writer, table_name):

    # extract the table primary key and table names
    primary_key,columns = find_pk_tags(data_schema_path, table_name)
    table_data_folder = data_folder+table_name+".dat"

    row_count = 0 
    with open(table_data_folder, 'r') as file:
        for line in file:
            fields = line.strip().split('|')
            row_id = table_name+"_"+fields[0]  # Using cc_call_center_sk as the row ID +++
            m = Mutation(row_id)
            for col, value in zip(columns, fields):
                if value != '\\N':  # Handling null values
                    m.put(cf="info", cq=col, val=value)
                else:
                    m.put(cf="info", cq=col, val="NULL`")
            batch_writer.add_mutation(m)
            row_count+=1

    batch_writer.close()
    return row_count
