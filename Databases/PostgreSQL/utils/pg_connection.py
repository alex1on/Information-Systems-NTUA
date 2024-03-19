import psycopg2
from psycopg2 import OperationalError
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

def open_pg_connection():
    """
    Opens a connection to PostgreSQL
    """
    try:
        connection = psycopg2.connect(
            user=os.getenv("POSTGRESQL_USER"),
            password=os.getenv("POSTGRESQL_PASSWORD"),
            host=os.getenv("POSTGRESQL_HOST"),
            database=os.getenv("POSTGRESQL_DATABASE"),
            port=os.getenv("POSTGRESQL_PORT", "5432")
        )

        print("Connection to PostgreSQL DB successful")
        return connection
    except OperationalError as e:
        print(f"While trying to set up a connection to PostgreSQL the error '{e}' occurred.")
        return None

def close_pg_connection(connection):
    """
    Closes connection to PostgreSQL
    """
    if connection:
        connection.close()
        print("Connection to PostgreSQL DB closed")