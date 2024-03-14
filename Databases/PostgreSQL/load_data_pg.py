# load_data_to_pg.py
from utils.pg_connection import open_pg_connection, close_pg_connection
from utils.data_loader import load_table_data
import json
import sys
import os

# Load JSON configuration
def load_json_config(file_path):
    with open(file_path, 'r') as json_file:
        return json.load(json_file)

if __name__ == "__main__":

    # Determine the table list from command line argument
    table_list_name = sys.argv[1] if len(sys.argv) > 1 else "all_tables"
    
    schema_name = "tpcds"
    
    # Read the JSON configuration
    json_config = load_json_config('../distribution_structures.json')
    tables = json_config.get(table_list_name, [])
    
    # Open the database connection
    connection = open_pg_connection()
    
    if connection:
        data_dir = os.path.join(os.path.dirname(__file__), '../../../tpc_data')
        
        for table in tables:
            file_path = os.path.join(data_dir, f"{table}.dat")
            if os.path.exists(file_path):
                load_table_data(connection, schema_name, table, file_path)
            else:
                print(f"File for table {table} not found. Skipping.")
        
        # Close the database connection
        close_pg_connection(connection)
    else:
        print("Failed to open database connection")
