from cass_connection import open_connection, close_connection
import os

def create_keyspace_schema():
    cluster, session = open_connection()

    file_path = "./schema.cql"
    
    with open(file_path, 'r') as file:
        cql_schema_commands = file.read().split(';')
        for command in cql_schema_commands:
            command = command.strip()
            if command:
                session.execute(command)
    
    close_connection(cluster)

create_keyspace_schema()