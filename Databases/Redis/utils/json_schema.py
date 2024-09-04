import os
from tables import table_names, primary_keys, table_structure, data_types, mappings
import json

# It creates the json schema for the given table 
def create_json_schema(table_name, primary_key, table_columns, col_data_types):



    key_fields = []
    value_fields = []
    
    # Find the correct mapping for the given table_name
    table_mapping = next((m for m in mappings if m[1] == table_name), None)
    
    if table_mapping:
        ranges = table_mapping[0]
        
        for i, pk in enumerate(primary_key):
            # If there are multiple primary keys, ensure to get the corresponding range
            range_mapping = f"{ranges[i][0]}:{ranges[i][1]}"
            
            key_fields.append({
                "name": pk,
                "mapping": range_mapping,
                "type": "VARCHAR"
            })
    else:
        print(f"Error: No mapping found for table '{table_name}'")
        return None
    
    for column in table_columns:
        if column in primary_key:
            continue

        data_type = col_data_types[table_columns.index(column)]

        value_fields.append({
            "name": column,
            "mapping": column,
            "type": data_type
        })

    json_schema = {
        "tableName": table_name,
        "schemaName": "tpcds",  
        "key": {
            "dataFormat": "raw",
            "fields": key_fields
        },
        "value": {
            "dataFormat": "hash",
            "fields": value_fields
        }
    }

    return json_schema

# It writes the given json_schema in file_path
def write_json_schema():
    for i in range(len(table_names)):
        table_name = table_names[i]
        primary_key = primary_keys[i].split(', ')
        table_columns = table_structure[i].split(', ')
        col_data_types = data_types[i].split(', ')

        json_schema = create_json_schema(table_name, primary_key, table_columns, col_data_types)

        if json_schema:
            
            # Create the directory if it doesn't exist
            dir_path = "/home/user/schemas/"
            os.makedirs(dir_path, exist_ok=True)
            
            file_path = os.path.join(dir_path, f"{table_name}_schema.json")

            with open(file_path, 'w') as json_file:
                json.dump(json_schema, json_file, indent=4)


write_json_schema()           