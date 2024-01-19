#!/bin/bash

# Data directory path
datadir="../tpc_data"

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
