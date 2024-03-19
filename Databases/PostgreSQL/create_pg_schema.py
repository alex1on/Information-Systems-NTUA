from utils.pg_connection import open_pg_connection, close_pg_connection
import psycopg2

def create_schema(connection, schema_name='tpcds'):
    """
    Creates the specified schema in the PostgreSQL database if it doesn't exist.
    """
    cursor = connection.cursor()
    cursor.execute(f"CREATE SCHEMA IF NOT EXISTS {schema_name};")
    connection.commit()
    print(f"Schema '{schema_name}' created or already exists.")
    cursor.close()

def execute_sql_file(connection, file_path, schema_name='tpcds'):
    """
    Executes the SQL commands contained in a given file, handling errors for individual commands.
    This allows the process to skip over commands that might fail (e.g., due to duplicate constraints) and continue executing the rest.
    """
    cursor = connection.cursor()

    # Set the search_path to the new schema so all subsequent operations happen in this schema
    cursor.execute(f"SET search_path TO {schema_name};")
    
    with open(file_path, 'r') as file:
        # Split the script into individual commands on semicolons.
        # Note: This simplistic approach might not correctly handle semicolons within strings or comments.
        sql_commands = file.read().split(';')
        
        for command in filter(None, [cmd.strip() for cmd in sql_commands]):  # Strip and remove empty commands
            if command:  # Ensure command is not empty after stripping
                try:
                    cursor.execute(command)
                    connection.commit()
                except psycopg2.errors.DuplicateObject as e:
                    print(f"Skipping command due to duplication: {e}")
                    connection.rollback()
                except Exception as e:
                    print(f"Error executing command: {e}")
                    connection.rollback()
    cursor.close()
    print(f"Executed SQL script from file: {file_path} with individual command handling")


if __name__ == "__main__":

    # Open the database connection
    connection = open_pg_connection()

    if connection:
        create_schema(connection, 'tpcds')
        execute_sql_file(connection, 'utils/tpcds.sql')
        execute_sql_file(connection, 'utils/tpcds_ri.sql')

        # Close the database connection
        close_pg_connection(connection)
    else:
        print("Failed to open database connection")