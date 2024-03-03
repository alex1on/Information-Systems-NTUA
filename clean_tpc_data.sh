#!/bin/bash

# Description:
#   Data generated from the TPC-DS benchmark has the following delimiter "|". 
#   The dbs expect the escape character to not be the delimiter (as it by default on the generated data).
#   We force with this script the escape character to be the  "\n".


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Data directory path
datadir="../tpc_data" # change it accordingly

# Function to copy data into PostgreSQL table
copy_data() {
  local file="$1"
  local table_name=$(basename "$file" .dat)

  sed -i 's/|\{1\}$//' "$file" 

  echo "Data from $file cleaned."
}

# Loop through each file in the directory
for file in "$datadir"/*.dat; do
  if [ -f "$file" ]; then
    copy_data "$file"
  else
    echo "File $file not found. Skipping."
  fi
done
