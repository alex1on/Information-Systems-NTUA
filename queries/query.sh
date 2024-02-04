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

    # Needed as duration is saved as "number" and not directly a string
    duration_striped="${duration:1:-1}"

    seconds=$((duration_striped / 1000))
    minutes=$((seconds / 60))
    hours=$((minutes / 60))

    remaining_milliseconds=$((duration_striped % 1000))
    remaining_seconds=$((seconds % 60))
    remaining_minutes=$((minutes % 60))

    # Save to output file with the following format: HH:mm:ss.xxx
    formatted_duration=$(printf "%02d:%02d:%02d.%03d" "$hours" "$remaining_minutes" "$remaining_seconds" "$remaining_milliseconds")

    # Append query and duration to results.txt
    echo "Query: $QUERY" >> results.txt
    echo "Duration: $formatted_duration" >> results.txt
    echo "----------------------------" >> results.txt

done
