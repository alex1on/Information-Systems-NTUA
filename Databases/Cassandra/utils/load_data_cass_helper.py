import json
import os
import subprocess

def load_table_cass(keyspace, table, structure):
    file_path = "../../../../tpc_data/" + table + ".dat"

    CASSANDRA_HOST = os.getenv('CASSANDRA_HOST')
    CASSANDRA_USER = os.getenv('CASSANDRA_USER')    
    CASSANDRA_PASSWORD = os.getenv('CASSANDRA_PASSWORD')

    # Construct the COPY command
    command = f"COPY {keyspace}.{table} ({structure}) FROM '{file_path}' WITH DELIMITER='|' AND HEADER=FALSE"
    
    # Use the subprocess module to call cqlsh with the COPY command
    cqlsh_command = [
        'cqlsh', 
        CASSANDRA_HOST, 
        '-u', CASSANDRA_USER, 
        '-p', CASSANDRA_PASSWORD, 
        '-e', command
    ]

    # Use the subprocess module to call cqlsh with the COPY command
    try:
        # Note: Adjust the path to cqlsh if it's not in your PATH environment variable
        subprocess.run(cqlsh_command, check=True, text=True)
        print(f"Data successfully loaded into {keyspace}.{table} from {file_path}")
    except subprocess.CalledProcessError as e:
        print(f"Failed to load data: {e}")

def load_config_file():
    file_path = "../../distribution_structures.json"
    with open(file_path, 'r') as file:
        data = json.load(file)

    return data