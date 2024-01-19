#!/bin/bash

# Prompt user for PostgreSQL username
read -p "Enter PostgreSQL username: " username

# Check if username is provided
if [ -z "$username" ]; then
  echo "Username is required."
  exit 1
fi

# PostgreSQL connection parameters
host="192.168.1.1"
database="trino"
schema="tpcds"

# Log in to psql and create 'tpcds' schema
psql -h "$host" -U "$username" -d "$database" -W <<EOF

-- Create 'tpcds' schema if not exists
CREATE SCHEMA IF NOT EXISTS $schema;

-- Set search_path to 'tpcds'
SET search_path TO $schema;

-- Run the scripts to create tables
\i ../../DSGen-software-code-3.2.0rc1/tools/tpcds.sql;
\i ../../DSGen-software-code-3.2.0rc1/tools/tpcds_ri.sql;
-- Exit psql
\q
EOF

# Check if psql command was successful
if [ $? -eq 0 ]; then
  echo "The schema was created successfully."
else
  echo "Error creating the schema."
fi
