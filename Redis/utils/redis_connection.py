import os
import redis
from dotenv import load_dotenv

# Load environment variables from a .env file
load_dotenv()

# Get Redis connection details from environment variables
redis_host = os.getenv('REDIS_HOST')
redis_port = int(os.getenv('REDIS_PORT', '6379'))
redis_db = int(os.getenv('REDIS_DB', '0'))
redis_password = os.getenv('REDIS_PASSWORD')

# Connect to Redis with password
def open_connection():
    redis_client = redis.StrictRedis(host=redis_host, port=redis_port, db=redis_db, password=redis_password)
    print(f"Connected to Redis at {redis_host}:{redis_port}, database: {redis_db}, password: {'Yes' if redis_password else 'No'}")
    return redis_client

def close_connection(redis_client):
    # Close the Redis connection
    redis_client.close()
