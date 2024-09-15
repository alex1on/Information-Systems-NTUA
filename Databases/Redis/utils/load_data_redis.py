import argparse
import json
from redis_connection import open_connection, close_connection
from load_data_redis_helper import load_data

# Function to load JSON configuration
def load_json_config(file_path):
    with open(file_path, 'r') as json_file:
        return json.load(json_file)

# Main function to handle loading data based on partition or specific table
def main(args):
    # Connect to Redis
    redis_client = open_connection()

    if args.partition:
        # Load tables from specified partition
        json_config = load_json_config('../distribution_structures.json')
        partition_info = next((p for p in json_config['partitions'] if p['id'] == args.partition), None)
        if partition_info:
            tables = partition_info.get('redis_tables', [])
            for table in tables:
                # Load table data
                load_data(redis_client, table=table, cleanup=args.cleanup, batch_processing=args.batch_processing)
    else:
        # Load data for a specific table
        load_data(redis_client, table=args.table, cleanup=args.cleanup, batch_processing=args.batch_processing)

    close_connection(redis_client)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Prepare Redis table benchmark.')
    parser.add_argument('--table', type=str, help='Name of the table to load in Redis.')
    parser.add_argument('--partition', type=int, choices=[1, 2], help='Partition ID to load data for all tables in the partition.')
    parser.add_argument('--cleanup', action='store_true', help='Clean up the data file after processing. Default is not to clean up.')
    parser.add_argument('--batch_processing', type=str, choices=['true', 'false'], default='true', help='Enable batch processing (true/false). Default is true.')
    args = parser.parse_args()

    # Validate arguments: either table or partition should be provided, not both
    if not args.table and not args.partition:
        parser.error('Either --table or --partition must be provided.')
    elif args.table and args.partition:
        parser.error('Both --table and --partition cannot be provided together.')

    main(args)
    