import os
from utils.redis_connection import open_connection, close_connection
from utils.data_loader import load_data

# Connect to Redis
redis_client = open_connection()

# Insert the data
load_data(redis_client)

# Close connection to Redis
close_connection(redis_client)
    