import json

# It creates the json schema for the given table 
def create_json_schema(table_name, primary_key, table_columns, data_types):
    key_fields = []
    value_fields = []

    for column in table_columns:
        data_type = data_types[table_columns.index(column)]

        if column in primary_key:
            key_fields.append({
                "name": column,
                "mapping": column,
                "type": data_type
            })
        else:
            value_fields.append({
                "name": column,
                "mapping": column,
                "type": data_type
            })

    json_schema = {
        "tableName": table_name,
        "schemaName": "tpcds",  
        "key": {
            "dataFormat": "json",
            "fields": key_fields
        },
        "value": {
            "dataFormat": "json",
            "fields": value_fields
        }
    }

    return json_schema

# It writes the given json_schema in file_path
def write_json_schema(json_schema, file_path):
    with open(file_path, 'w') as json_file:
        json.dump(json_schema, json_file, indent=4)