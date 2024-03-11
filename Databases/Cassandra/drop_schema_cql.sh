#!/bin/bash

# Determine the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Read Cassandra parameters and keyspace from .env file
source "$SCRIPT_DIR/../../.env"

# List of tables you want to truncate (optional if you decide to manually specify tables)
# Note: If your schema contains many tables or you prefer not to hardcode,
# you might need a more dynamic approach to list and truncate tables.
# tables=("table1" "table2" "table3")
tables=$(cqlsh -u "$CASSANDRA_USER" -p "$CASSANDRA_PASSWORD" "$CASSANDRA_HOST" -e "SELECT table_name FROM system_schema.tables WHERE keyspace_name = '$CASSANDRA_KEYSPACE';" | awk 'NR > 3 { print $1 }' | head -n -2)

# Log in to cqlsh and truncate tables
for table in "${tables[@]}"; do
    echo "Truncating table $table in keyspace $CASSANDRA_KEYSPACE..."
    cqlsh -u "$CASSANDRA_USER" -p "$CASSANDRA_PASSWORD" "$CASSANDRA_HOST" -e "TRUNCATE TABLE $CASSANDRA_KEYSPACE.$table;"
    if [ $? -eq 0 ]; then
      echo "Table $table truncated successfully."
    else
      echo "Error truncating table $table."
    fi
done

# Drop the keyspace
echo "Dropping keyspace $CASSANDRA_KEYSPACE..."
cqlsh -u "$CASSANDRA_USER" -p "$CASSANDRA_PASSWORD" "$CASSANDRA_HOST" -e "DROP KEYSPACE IF EXISTS $CASSANDRA_KEYSPACE;"

# Check if the DROP KEYSPACE command was successful
if [ $? -eq 0 ]; then
  echo "The keyspace $CASSANDRA_KEYSPACE was dropped successfully."
else
  echo "Error dropping keyspace $CASSANDRA_KEYSPACE."
fi
