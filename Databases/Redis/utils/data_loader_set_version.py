import os 
import redis
import json
from utils.tables import table_names, primary_keys, table_structure, data_types
from utils.json_schema import create_json_schema, write_json_schema

def prepare_redis_hashes(redis_client, schema_name, table_name, primary_key, table_columns, data_types, lines):
    hashes = []

    for line in lines:
        values = line.strip('|').split('|')

        # Extract primary key values
        primary_key_values = {primary_key[i]: values[i] for i in range(len(primary_key))}
        primary_key_json = json.dumps(primary_key_values)

        # Create Redis hash key with schema-name:table-name prefix
        hash_key = f"{schema_name}:{table_name}:{':'.join(primary_key_values.values())}"

        # Create Redis set command
        set_command = f'SET \'{hash_key}\' '

        # Create Redis hash values
        hash_values = {column: values[table_columns.index(column)] for column in table_columns if column not in primary_key}
        hash_values_json = json.dumps(hash_values)

        set_command += f'\'{hash_values_json}\''

        hashes.append(set_command)

    return hashes

def load_data(redis_client):
    schema_name = "tpcds"
    remote_host = 'okeanos-data'
    file_prefix = "~/Information_systems/tpc_data/"
    file_suffix = ".dat"

    for i in range(1, len(table_names)):
        # Get table info
        table_name = table_names[i]
        primary_key = primary_keys[i].split(', ')
        table_columns = table_structure[i].split(', ')
        types = data_types[i].split(', ')

        # Define data file path
        file_path = "../tpc_data/" + table_name + ".dat"
        remote_file = file_prefix + table_name + file_suffix

        os.system('scp "%s:%s" "%s"' % (remote_host, remote_file, file_path))

        # Create and write JSON schema
        json_schema = create_json_schema(table_name, primary_key, table_columns, types)
        schema_file_path = f"{table_name}_schema.json"
        write_json_schema(json_schema, schema_file_path)

        # Read file in chunks
        with open(file_path, 'r') as file:
            chunk_size = 1000  # Adjust the chunk size based on your needs
            while True:
                lines = file.readlines(chunk_size)
                if not lines:
                    break

                # Prepare the Redis set commands for the current chunk
                set_commands = prepare_redis_hashes(redis_client, schema_name, table_name, primary_key, table_columns, data_types, lines)

                # Execute Redis set commands
                for set_command in set_commands:
                    print(set_command)
                    redis_client.execute_command(set_command)

        os.system('rm "%s"' % (file_path))