#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Read Cassandra parameters from .env file
source "$SCRIPT_DIR/../../.env"

# Source the table definitions from tables.sh
source "$SCRIPT_DIR/../tables.sh"

# Set default table list and structure
table_list_name="all_tables"
table_structure_name="${table_list_name}_structure"

# If a parameter is given, use it to determine the table list and structure
if [ $# -gt 0 ]; then
    table_list_name="${1}"
    table_structure_name="${1}_structure"
fi

# Dynamically set tables and table_structure arrays
tables=("${!table_list_name}")
table_structure=("${!table_structure_name}")

# Data directory path
datadir="$SCRIPT_DIR/../tpc_data"

# Establish a connection to Cassandra
if ! cqlsh -u "$CASSANDRA_USER" -p "$CASSANDRA_PASSWORD" -e 'SELECT release_version FROM system.local;' "$CASSANDRA_HOST" > /dev/null 2>&1; then
  echo "Failed to connect to Cassandra. Exiting."
  exit 1
fi

# Function to copy data into Cassandra table
copy_data() {
  local file="$1"
  local table_structure_cql="$2"
  local table_name=$(basename "$file" .dat)

  COPY_COMMAND="COPY $CASSANDRA_KEYSPACE.$table_name ($table_structure_cql) FROM '$file' WITH DELIMITER='|' AND HEADER=FALSE"   

  echo "Copying data to $CASSANDRA_KEYSPACE.$table_name"
  
  cqlsh -u "$CASSANDRA_USER" -p "$CASSANDRA_PASSWORD" "$CASSANDRA_HOST" -e "$COPY_COMMAND"

  echo "Data from $file copied into $CASSANDRA_KEYSPACE.$table_name"

  rm -f "$file"
}

# Loop through each table in the correct order
for ((i=0; i<${#tables[@]}; i++)); do
  table="${tables[$i]}"
  file="$datadir/$table.dat"
  structure="${table_structure[$i]}"  # Get the corresponding table_structure value

  # remote_file="~/Information_systems/tpc_data/$table.dat"

  # scp "okeanos-data:$remote_file" "$file"

  if [ -f "$file" ]; then
    copy_data "$file" "$structure"
  else
    echo "File $file not found. Skipping table $table."
  fi
done

echo "Data copy complete."

# Exit the script
exit 0
