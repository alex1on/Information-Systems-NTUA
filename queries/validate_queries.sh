#!/bin/bash

# Description:
# This script validates SQL queries using Trino's "EXPLAIN (TYPE VALIDATE) <query>" option. 
# It checks the format and correctness of queries by executing them in a Trino environment.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ../.env

# Check if required environment variables are set
if [ -z "$TRINO_HOST" ] || [ -z "$TRINO_PORT" ]; then
    echo "Error: TRINO_HOST and TRINO_PORT environment variables are not set."
    exit 1
fi

# Directory containing SQL queries
QUERY_DIR="../../queries"

# Define Trino command with host and port
TRINO_COMMAND="./../../trino $TRINO_HOST:$TRINO_PORT"

# Output file for query validation results
OUTPUT_FILE="query_validation.txt"

# Clear the output file
> "$OUTPUT_FILE"

# Iterate through query files
for query_file in "$QUERY_DIR"/*.sql; do

    # Extract the SQL query from the file
    QUERY=$(cat "$query_file")

    # Create a unique name for the query based on the file name
    QUERY_NAME=$(basename "$query_file" .sql)

    FULL_QUERY="USE postgresql.tpcds; EXPLAIN (TYPE VALIDATE) $QUERY"

    # Execute the Trino command and capture the result
    RESULT=$($TRINO_COMMAND --execute "$FULL_QUERY" 2>&1)

    # Check if the result contains "true"
    if [[ $RESULT == *"true"* && $RESULT == *"USE"* ]]; then
        VALIDITY=true
    else
        VALIDITY=false
    fi

    # Append the result to the output file
    echo "query_name: $QUERY_NAME -> valid: $VALIDITY" >> "$OUTPUT_FILE"

done
