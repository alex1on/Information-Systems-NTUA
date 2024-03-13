import argparse
from redis_connection import open_connection, close_connection
from load_data_redis_helper import load_data

def load_table_benchmark(table, cleanup=True, batch_processing=True):
    # Connect to Redis
    redis_client = open_connection()

    # Insert the data
    load_data(redis_client, table=table, cleanup=cleanup, batch_processing=batch_processing)

    # Close connection to Redis
    close_connection(redis_client)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Prepare Redis table benchmark.')
    parser.add_argument('table', type=str, help='Name of the table to prepare benchmark for.')
    parser.add_argument('--cleanup', type=str, choices=['true', 'false'], default='true', help='Whether to clean up the file after processing (true/false). Default is true.')
    parser.add_argument('--batch_processing', type=str, choices=['true', 'false'], default='true', help='Enable batch processing (true/false). Default is true.')
    args = parser.parse_args()

    cleanup = args.cleanup.lower() == 'true'
    batch_processing = args.batch_processing.lower() == 'true'
    load_table_benchmark(args.table, cleanup, batch_processing)

    