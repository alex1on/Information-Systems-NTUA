#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Read PostgreSQL parameters from .env file
source ../.env

schema_file="$SCRIPT_DIR/schema.cql"

# Log in to psql and create 'tpcds' schema
cqlsh -u "$CASSANDRA_USER" -p "$CASSANDRA_PASSWORD" "$CASSANDRA_HOST" -f "$schema_file"

# Check if psql command was successful
if [ $? -eq 0 ]; then
  echo "The schema was created successfully."
else
  echo "Error creating the schema."
fi
