import psycopg2
import os

def load_table_data(connection, schema_name, table_name, file_path, delimiter='|', encoding='LATIN1'):
    """
    Loads data from a .dat file into a PostgreSQL table.
    """
    cursor = connection.cursor()

    # Set client encoding
    cursor.execute(f"SET client_encoding TO '{encoding}';")
    
    # Construct the COPY command
    sql_command = f"COPY {schema_name}.{table_name} FROM stdin WITH DELIMITER '{delimiter}' CSV NULL AS '';"
    
    # Open the .dat file and use copy_expert to load the data
    with open(file_path, 'r') as file:
        cursor.copy_expert(sql=sql_command, file=file)
        
    connection.commit()
    print(f"Data from {file_path} copied into {schema_name}.{table_name}")
    cursor.close()
