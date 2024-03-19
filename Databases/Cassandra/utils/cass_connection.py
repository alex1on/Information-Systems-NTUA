import os
from cassandra.cluster import Cluster
from cassandra.auth import PlainTextAuthProvider
from dotenv import load_dotenv

# Load environment variables from a .env file
load_dotenv()

# Get Cassandra connection details from enviorment variables
CASSANDRA_HOST = os.getenv('CASSANDRA_HOST')
CASSANDRA_PORT = int(os.getenv("CASSANDRA_PORT", '9042'))
CASSANDRA_USER = os.getenv('CASSANDRA_USER')
CASSANDRA_PASSWORD = os.getenv('CASSANDRA_PASSWORD')
CASSANDRA_KEYSPACE = os.getenv('CASSANDRA_KEYSPACE')

# Connect to Cassandra
def open_connection():
    # Configure authentication
    auth_provider = PlainTextAuthProvider(username=CASSANDRA_USER, password=CASSANDRA_PASSWORD)

    # Connect to the cluster
    cluster = Cluster([CASSANDRA_HOST], port=CASSANDRA_PORT, auth_provider=auth_provider)
    session = cluster.connect()

    # Connect to specific keyspace only if it exists in the Cassandra cluster
    if check_keyspace_exists(session, CASSANDRA_KEYSPACE):
        session.set_keyspace(CASSANDRA_KEYSPACE)
    return cluster, session

# Close Cassandra connection
def close_connection(cluster):
    cluster.shutdown()

# Check if keyspace specified in the env file exists.
# Check only needed for newly created keyspaces. 
def check_keyspace_exists(session, keyspace_name):
    query = "SELECT keyspace_name FROM system_schema.keyspaces WHERE keyspace_name = %s"
    rows = session.execute(query, [keyspace_name])
    return any(row.keyspace_name == keyspace_name for row in rows)