from utils.tables import table_names, primary_keys, table_structure
import redis
import os 

def prepare_redis_hashes(table_name, primary_key, table_columns, lines):
    hashes = {}

    for line in lines:
        # Seperate column values. (Also clean the \n from the end of each line)
        values = [value.strip() for value in line.split('|')]
        #values = line.strip('|').split('|')

        # Extract primary key values
        primary_key_values = [values[table_columns.index(pk)] for pk in primary_key]

        # Create Redis hash key
        hash_key = f"tpcds.{table_name}.{':'.join([f'{pk}:{values[table_columns.index(pk)]}' for pk in primary_key])}"

        # Create Redis hash values
        # For each hash value we choose "columns" that are not in the hash key and its values are not empty. 
        # We need the last part to properly show NULL values when the redis data is imported to trino.
        hash_values = {column: values[table_columns.index(column)] for column in table_columns if column not in primary_key or values[table_columns.index(column)] != ''}

        # Remove empty values
        hash_values = {key: value for key, value in hash_values.items() if value != ''}

        # Store hash in dictionary
        hashes[hash_key] = hash_values

    return hashes


def load_data(redis_client):
    remote_host = 'okeanos-data'
    file_prefix = "~/Information_systems/tpc_data/"
    file_suffix = ".dat"

    for i in range(len(table_names)):
        # Get table info
        table_name = table_names[i]
        primary_key = primary_keys[i].split(', ')
        table_columns = table_structure[i].split(', ')

        # Define data file path
        file_path = "../tpc_data/" + table_name + ".dat"
        remote_file = file_prefix + table_name + file_suffix

        os.system('scp "%s:%s" "%s"' % (remote_host, remote_file, file_path))

        # Read file in chunks
        with open(file_path, 'r') as file:
            chunk_size = 1000  # Adjust the chunk size based on your needs
            while True:
                lines = file.readlines(chunk_size)
                if not lines:
                    break
                # Prepare the Redis hashes for the current chunk
                hashes = prepare_redis_hashes(table_name, primary_key, table_columns, lines)

                # Load hashes in Redis
                for h in hashes:
                    redis_client.hset(h, mapping=hashes[h])

        os.system('rm "%s"' % (file_path))
