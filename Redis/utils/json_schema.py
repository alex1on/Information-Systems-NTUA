from tables import table_names, primary_keys, table_structure, data_types
import json

# It creates the json schema for the given table 
def create_json_schema(table_name, primary_key, table_columns, col_data_types):

    key_fields = []
    value_fields = []

    for column in table_columns:
        data_type = col_data_types[table_columns.index(column)]

        if column in primary_key and len(primary_key) < 2:
            PREFIX_LEN=len("tpcds."+ table_name + "." + column + ":")
            key_fields.append({
                "name": column,
                "mapping": PREFIX_LEN,
                "type": "VARCHAR(64)"
            })
        else:
            value_fields.append({
                "name": column,
                "mapping": column,
                "type": data_type
            })

    if len(key_fields) == 0:
            key_fields.append({
                "name": "primary_id",
                "type": "VARCHAR(64)",
                "hidden": True
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
        print(table_name)

        json_schema = create_json_schema(table_name, primary_key, table_columns, col_data_types)

        file_path = "/home/user/schemas/" + table_name + "_schema.json"

        with open(file_path, 'w') as json_file:
            json.dump(json_schema, json_file, indent=4)


write_json_schema()           