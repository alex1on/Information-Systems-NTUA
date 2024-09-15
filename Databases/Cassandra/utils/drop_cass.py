from cass_connection import open_connection, close_connection
import os

CASSANDRA_KEYSPACE = os.getenv('CASSANDRA_KEYSPACE')

# Connect to Cassandra
cluster, session = open_connection()

# Drop keyspace
session.execute(f"DROP KEYSPACE IF EXISTS {CASSANDRA_KEYSPACE}", timeout=60)

# Close connection
close_connection(cluster)