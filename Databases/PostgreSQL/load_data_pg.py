from utils.pg_connection import open_pg_connection, close_pg_connection
from utils.data_loader import load_table_data
import json
import os
import argparse

# Load JSON configuration
def load_json_config(file_path):
    with open(file_path, 'r') as json_file:
        return json.load(json_file)

# Parse command-line arguments
def parse_args():
    parser = argparse.ArgumentParser(description="Load data into the tpcds schema in PostgreSQL.")
    parser.add_argument('-p', '--partition', type=int, choices=[1, 2],
                        help="Partition ID to load `pg_tables` from the specified partition.")
    return parser.parse_args()

if __name__ == "__main__":

    args = parse_args()
    
    schema_name = "tpcds"
    
    # Read the JSON configuration
    json_config = load_json_config('../distribution_structures.json')

    if args.partition:
        # Read partition-specific tables
        partition_info = next((p for p in json_config['partitions'] if p['id'] == args.partition), None)
        if partition_info:
            tables = partition_info.get('pg_tables', [])
        else:
            print(f"Partition with ID {args.partition} not found.")
            exit(1)
    else:
        # Read all_tables
        tables = json_config.get('all_tables', [])
    
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
