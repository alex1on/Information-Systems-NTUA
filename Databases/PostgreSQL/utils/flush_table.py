import sys
from pg_connection import open_pg_connection, close_pg_connection

def flush_table_data(connection, table_name, schema_name="tpcds"):
    """
    Deletes all data from a specified table within a given schema.
    """
    cursor = connection.cursor()
    try:
        # SQL command to delete all rows from the specified table
        flush_query = f"DELETE FROM {schema_name}.{table_name};"
        cursor.execute(flush_query)
        connection.commit()
        print(f"Data flushed from table: {schema_name}.{table_name}")
    except Exception as e:
        print(f"An error occurred while flushing data from {table_name}: {e}")
        connection.rollback()
    finally:
        cursor.close()

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python flush_table_data.py <table_name>")
        sys.exit(1)
    
    table_name = sys.argv[1]
    schema_name = "tpcds"
    
    # Open the database connection
    connection = open_pg_connection()
    
    if connection:
        flush_table_data(connection, table_name, schema_name)
        # Close the database connection
        close_pg_connection(connection)
    else:
        print("Failed to open database connection")
