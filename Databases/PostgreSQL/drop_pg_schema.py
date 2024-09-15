from utils.pg_connection import open_pg_connection, close_pg_connection

def drop_pg_schema(connection):
    """
    Drops the 'tpcds' schema and all its contents.
    """
    try:
        cursor = connection.cursor()
        
        # SQL command to drop the 'tpcds' schema
        drop_schema_sql = "DROP SCHEMA tpcds CASCADE;"
        cursor.execute(drop_schema_sql)
        connection.commit()
        print("Schema 'tpcds' and all its contents have been dropped.")
    except Exception as e:
        print(f"An error occurred: {e}")
        connection.rollback()
    finally:
        cursor.close()

# Drop the schema
if __name__ == "__main__":

    # Open the database connection
    connection = open_pg_connection()

    if connection:
        # Drop the pg schema
        drop_pg_schema(connection)

        # Close the database connection
        close_pg_connection(connection)
    else:
        print("Failed to open database connection")