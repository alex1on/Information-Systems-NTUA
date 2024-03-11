#!/bin/bash

# Determine the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Read PostgreSQL parameters from .env file
source "$SCRIPT_DIR/../../.env"

# Source the table_lists from ../tables.sh
source "$SCRIPT_DIR/../tables.sh"

# Data directory path
datadir="$SCRIPT_DIR/../../../tpc_data"

# Set default table list
table_list_name="all_tables"

# If a parameter is given, use it to determine the table list
if [ $# -gt 0 ]; then
    table_list_name="${1}"
fi

# Dynamically set tables
tables=("${!table_list_name}")

client_encoding="LATIN1"

# Establish a connection to PostgreSQL and set client encoding
#psql_command="PGPASSWORD='$password' psql -h '$host' -U '$username' -d '$database'"
psql_command="PGPASSWORD='$POSTGRESQL_PASSWORD' psql -h '$POSTGRESQL_HOST' -U '$POSTGRESQL_USER' -d '$POSTGRESQL_DATABASE' -c 'SET client_encoding TO $client_encoding;'"
eval "$psql_command -c 'SELECT 1;'" 
if [ $? -ne 0 ]; then
  echo "Failed to connect to PostgreSQL. Exiting."
  exit 1
fi

# Function to copy data into PostgreSQL table
copy_data() {
  local file="$1"
  local table_name=$(basename "$file" .dat)

  #sed 's/|\{1\}$//' "$file" > "$file".tmp

  #local file_tmp="$file".tmp

  # Execute the COPY command
  eval "$psql_command -c \"\\COPY $POSTGRESQL_SCHEMA.$table_name FROM '$file' WITH CSV DELIMITER '|' NULL as ''\""

  echo "Data from $file copied into $POSTGRESQL_SCHEMA.$table_name"


  rm "$file"
}

# Loop through each table
for table in "${tables[@]}"; do
  file="$datadir/$table.dat"
  if [ -f "$file" ]; then
    copy_data "$file"
  else
    echo "File $file not found. Skipping table $table."
  fi
done

echo "Data copy complete."

# Exit the script
exit 0
