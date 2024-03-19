#!/bin/bash

# Description:
# This script executes SQL queries from a specified directory against PostgreSQL, Cassandra and/or Redis using Trino.
# For each query, it runs two iterations, measures the duration, and stores the results in a CSV file.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ../.env

# Check if required environment variables are set
if [ -z "$TRINO_HOST" ] || [ -z "$TRINO_PORT" ]; then
    echo "Error: TRINO_HOST and TRINO_PORT environment variables are not set."
    exit 1
fi

# Directory containing SQL queries
if [ -z "$1" ]; then
    QUERY_DIR="../../queries"
elif [ "$1" == "partition1" ]; then
    QUERY_DIR="../../queries_partition1"
elif [ "$1" == "partition2" ]; then
    QUERY_DIR="../../queries_partition2"
else
    echo "Invalid parameter. Usage: $0 [partition1|partition2]"
    exit 1
fi

# Define Trino command with host and port
TRINO_COMMAND="./../../trino $TRINO_HOST:$TRINO_PORT"

# Create or clear the results directory
RESULTS_DIR="query_results"
#mkdir -p "$RESULTS_DIR"

datetime=$(date +"%Y%m%d_%H%M")

# Create CSV file for results
CSV_FILE="$RESULTS_DIR/queries_distributed_$1_$datetime.csv"
echo "query,run1,run2" > "$CSV_FILE"

# Queries to run
QUERIES=("003" "004" "007" "009" "018" "022" "024" "025" "028" "035" "038" "039" "049" "055" "056" "062" "064" "066" "071" "075" "078" "084" "086" "088" "090" "091")

format_duration() {
  local seconds=$(($1 / 1000))
  local minutes=$((seconds / 60))
  local hours=$((minutes / 60))
  local remaining_milliseconds=$(($1 % 1000))
  local remaining_seconds=$((seconds % 60))
  local remaining_minutes=$((minutes % 60))

  # Following format: HH:mm:ss.xxx
  printf "%02d:%02d:%02d.%03d" "$hours" "$remaining_minutes" "$remaining_seconds" "$remaining_milliseconds"
}

# Iterate through specified queries
for query in "${QUERIES[@]}"; do
    query_file="$QUERY_DIR/query$query.sql"

    # Extract the SQL query from the file
    QUERY=$(cat "$query_file")

    # Initialize variables for storing durations
    run1_duration=""
    run2_duration=""

    # Execute the query 2 times
    for i in {1..2}; do

        # Execute the query in Trino
        $TRINO_COMMAND --execute "$QUERY" > /dev/null

        # Calculate the duration in seconds
        duration_query="SELECT date_diff('millisecond', created, \"end\") AS duration FROM system.runtime.queries ORDER BY created DESC OFFSET 1 LIMIT 1;"
        duration=$($TRINO_COMMAND --execute "$duration_query")

        # Extract and format the duration
        duration_striped="${duration:1:-1}"

        formatted_duration=$(format_duration "$duration_striped")

         # Store the duration in the appropriate variable based on the run
        if [ "$i" == "1" ]; then
            run1_duration="$formatted_duration"
        else
            run2_duration="$formatted_duration"
        fi
    done

    # Save query and durations to results CSV file
    echo "$(basename "$query_file" .sql),$run1_duration,$run2_duration" >> "$CSV_FILE"
done
