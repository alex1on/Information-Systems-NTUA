#!/bin/bash

# Prompt user for PostgreSQL username
read -p "Enter PostgreSQL username: " username

# Prompt user for PostgreSQL password (using -s to hide input)
read -s -p "Enter PostgreSQL password: " password

# Check if the correct number of arguments is provided
if [ -z "$username" ] || [ -z "$password" ]; then
  echo "Username and Password are required."
  exit 1
fi

# PostgreSQL connection parameters
host="192.168.1.1"
database="trino"
schema="tpcds"  

# Data directory path
datadir="../tpc_data"

# List of tables ordered based on foreign key dependencies
tables=(
  "dbgen_version"
  "date_dim"
  "ship_mode"
  "warehouse"
  "web_site"
  "web_page"
  "income_band"
  "call_center"
  "reason"
  "item"
  "promotion"
  "customer_address"
  "customer_demographics"
  "household_demographics"
  "store"
  "time_dim"
  "inventory"
  "catalog_page"
  "customer"
  "web_sales"
  "web_returns"
  "store_sales"
  "store_returns"
  "catalog_sales"
  "catalog_returns"
)

client_encoding="LATIN1"

# Establish a connection to PostgreSQL
#psql_command="PGPASSWORD='$password' psql -h '$host' -U '$username' -d '$database'"
psql_command="PGPASSWORD='$password' psql -h '$host' -U '$username' -d '$database' -c 'SET client_encoding TO $client_encoding;'"
eval "$psql_command -c 'SELECT 1;'" 
if [ $? -ne 0 ]; then
  echo "Failed to connect to PostgreSQL. Exiting."
  exit 1
fi

# Function to copy data into PostgreSQL table
copy_data() {
  local file="$1"
  local table_name=$(basename "$file" .dat)

  sed 's/|\{1\}$//' "$file" > "$file".tmp

  local file_tmp="$file".tmp

  # Execute the COPY command
  eval "$psql_command -c \"\\COPY $schema.$table_name FROM '$file_tmp' WITH CSV DELIMITER '|' NULL ''\""

  echo "Data from $file copied into $schema.$table_name"

  rm "$file_tmp"
}

# Loop through each table in the correct order
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
