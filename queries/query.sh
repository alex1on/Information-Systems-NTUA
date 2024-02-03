#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ../.env
# Check if required environment variables are set
if [ -z "$TRINO_HOST" ] || [ -z "$TRINO_PORT" ]; then
    echo "Error: TRINO_HOST and TRINO_PORT environment variables are not set."
    exit 1
fi

# List of databases 
DATABASES=("postgresql" "cassandra" "redis")

# Table to query
TABLE="store_returns"

# Define Trino command with host and port
TRINO_COMMAND="./../../trino $TRINO_HOST:$TRINO_PORT"

# Create or clear the results file
echo "" > results.txt


for db in "${DATABASES[@]}"; do

    # Define the query
    QUERY="SELECT AVG(sr_return_amt) FROM $db.tpcds.$TABLE;"
    echo "Running $QUERY..."
    
    # Execute the query in trino
    $TRINO_COMMAND --execute "$QUERY" > /dev/null

    # Calculate the duration in seconds
    duration_query="SELECT date_diff('millisecond', created, \"end\") AS duration FROM system.runtime.queries ORDER BY created DESC OFFSET 1 LIMIT 1;"
    duration=$($TRINO_COMMAND --execute "$duration_query")   

    # Append query and duration to results.txt
    echo "Query: $QUERY" >> results.txt
    echo "Duration: $duration miliseconds" >> results.txt
    echo "----------------------------" >> results.txt

done
