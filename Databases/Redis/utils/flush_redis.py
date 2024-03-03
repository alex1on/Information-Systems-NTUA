import os
from redis_connection import open_connection, close_connection

# Connect to Redis
redis_client = open_connection()

# Flush data in Redis
redis_client.flushall()

# Close connection to redis
close_connection(redis_client)