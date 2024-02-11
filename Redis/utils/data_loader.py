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

def load_table(redis_client, index, batch_processing, cleanup):
    remote_host = 'okeanos-data'
    file_prefix = "~/Information_systems/tpc_data/"
    file_suffix = ".dat"
    
    # Get table info
    table_name = table_names[index]
    primary_key = primary_keys[index].split(', ')
    table_columns = table_structure[index].split(', ')

    # Define data file path
    file_path = "../../tpc_data/" + table_name + ".dat"
    remote_file = file_prefix + table_name + file_suffix

    os.system('scp "%s:%s" "%s"' % (remote_host, remote_file, file_path))

    # Read file in chunks
    if batch_processing:
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
    
    else:
        with open(file_path, 'r') as file:
            lines = file.readlines()

            # Prepare the Redis hashes for the whole file
            hashes = prepare_redis_hashes(table_name, primary_key, table_columns, lines)

            # Load hashes in Redis
            for h in hashes:
                redis_client.hset(h, mapping=hashes[h])

    if cleanup:
        clean_file(file_path)


def load_data(redis_client, batch_processing=True, table=None, cleanup=True):
    if table:
        table_index = table_names.index(table)
        load_table(redis_client, table_index, batch_processing, cleanup)
    else:
        for i in range(len(table_names)):
            load_table(redis_client, i, batch_processing, cleanup)

def clean_file(file_path):
    os.system('rm "%s"' % (file_path))