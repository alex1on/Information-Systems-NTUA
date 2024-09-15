import re
import sys
from tables import primary_keys

def replace_primary_keys_with_cast(query):
    # Iterate over primary_keys, split on commas for multi-column primary keys
    for key in primary_keys:
        columns = [col.strip() for col in key.split(",")]

        for column in columns:
            # Prevent replacing columns already within a CAST()
            # Replace <table>.<primary_key> if it's not already inside a CAST()
            query = re.sub(rf'(?<!CAST\()\b(\w+)\.{column}\b(?!\s*AS\s*INTEGER)', r'CAST(\1.' + column + ' AS INTEGER)', query)

            # Replace standalone <primary_key> if not already inside a CAST()
            query = re.sub(rf'(?<!CAST\()\b{column}\b(?!\s*AS\s*INTEGER)', f'CAST({column} AS INTEGER)', query)

    return query

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python modify_query.py '<SQL QUERY>'")
        sys.exit(1)

    # Get the SQL query from the argument
    query = sys.argv[1]

    # Replace the primary keys with CAST version
    modified_query = replace_primary_keys_with_cast(query)

    # Output the modified query
    print(modified_query)
