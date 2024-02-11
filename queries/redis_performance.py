import sys, os
import random
#sys.path.append('../Redis/utils')
sys.path.append(os.path.join(os.path.dirname(sys.path[0]),'Redis/'))

from utils.tables import table_names, primary_keys, table_structure, data_types
from utils.data_loader import load_data, clean_file
from utils.redis_connection import open_connection, close_connection

def prep_redis_table_benchmark(table):
    redis_client= open_connection()

    # Load the table contents to Redis cache. The file is not deleted as it will be processed later in this function
    load_data(redis_client, True, table, False)

    file_path = "../../tpc_data/" + table + ".dat"

    with open(file_path, 'r') as file:
        lines = file.readlines()

    random_table_item = random.choice(lines).split('|')

    table_index = table_names.index(table)
    pk_columns = primary_keys[table_index].split(', ')
    col_data_type = data_types[table_index].split(', ')

    pk_values = []
    for pk_column in pk_columns:
        col_index = table_structure[table_index].split(', ').index(pk_column)
        if col_data_type[col_index] == 'INTEGER':
            pk_values.append(random_table_item[col_index])
        else:
            pk_values.append("'" + random_table_item[col_index] + "'")


    clean_file(file_path)

    close_connection(redis_client)

    return_stmt = ""
    for i in range(len(pk_values)):
        if return_stmt == "":
            return_stmt = pk_columns[i] + ' = ' + pk_values[i] 
        else:
            return_stmt += " AND " + pk_columns[i] + ' = ' + pk_values[i] 

    print(return_stmt)

    return return_stmt

prep_redis_table_benchmark(sys.argv[1])



