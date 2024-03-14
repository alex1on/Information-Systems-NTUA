import argparse
import os
import json
from cass_connection import open_connection, close_connection
from load_data_cass_helper import load_table_cass, load_config_file



def load_alltables():
    print()

def load_partition(partition_id):
    CASSANDRA_KEYSPACE = os.getenv('CASSANDRA_KEYSPACE')

    config_data = load_config_file()

    partitions = config_data.get('partitions', [])
    partition = None

    # Search for the desired partition
    for part in partitions:
        if part.get('id') == partition_id:
            partition = part
            break

    if partition:
        part_tables = partition.get('cass_tables')
        alltables = config_data.get('all_tables')
        tables_structure = config_data.get('all_tables_structure')

        for table in part_tables:
            load_table_cass(CASSANDRA_KEYSPACE, table, tables_structure[alltables.index(table)])
    else:
        print(f"Error: Partition with ID {partition_id} does not exist.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Load Data to Cassandra cluster.')
    parser.add_argument('--alltables', type=str, choices=['true', 'false'], default='false', help='Whether to add all the tables to the Cassandra cluster. Default is false')
    parser.add_argument('--partition', type=int, help='Specify which partition to follow specified in the distribution_structures.json file')
    args = parser.parse_args()

    alltables = args.alltables.lower() == 'true'
    partition = args.partition

    if not alltables and partition is None:
        parser.error("Partition argument is obligatory when alltables is false.")
    elif alltables and partition is not None:
        print("Warning: Ignoring partition argument since alltables is true.")
    
    if alltables:
        load_alltables()
    else:
        load_partition(partition)