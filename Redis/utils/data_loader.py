from utils.tables import tables, primary_keys, table_structure
import redis
import os 

def prepare_redis_hashes(table_name, primary_key, table_columns, lines):
    hashes = {}

    for line in lines:
        values = line.strip('|').split('|')

        # Extract primary key values
        primary_key_values = [values[table_columns.index(pk)] for pk in primary_key]

        # Create Redis hash key
        hash_key = f"{table_name}:{':'.join(primary_key_values)}"

        # Create Redis hash values
        hash_values = {column: values[table_columns.index(column)] for column in table_columns if column not in primary_key}

        # Remove empty values
        hash_values = {key: value for key, value in hash_values.items() if value != '""'}

        # Store hash in dictionary
        hashes[hash_key] = hash_values

    return hashes


def load_data(redis_client):

    for i in range(16, len(tables)):
        # Get table info
        table_name = tables[i]
        primary_key = primary_keys[i].split(', ')
        table_columns = table_structure[i].split(', ')

        # Define data file path
        file_path = "../tpc_data/" + table_name + ".dat"

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
