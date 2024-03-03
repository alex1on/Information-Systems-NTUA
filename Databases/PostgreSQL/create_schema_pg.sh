#!/bin/bash

# Determine the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Read PostgreSQL parameters from .env file
source ../../.env

# Log in to psql and create the schema
PGPASSWORD="$POSTGRESQL_PASSWORD" psql -h "$POSTGRESQL_HOST" -U "$POSTGRESQL_USER" -d "$POSTGRESQL_DATABASE" <<EOF

-- Create the schema if it does not exist
CREATE SCHEMA IF NOT EXISTS $POSTGRESQL_SCHEMA;

-- Set the search_path to the schema
SET search_path TO $POSTGRESQL_SCHEMA;

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
