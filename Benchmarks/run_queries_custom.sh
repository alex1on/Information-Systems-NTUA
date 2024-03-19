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

# List of databases
DATABASES=("postgresql" "cassandra")

# Directory containing SQL queries
QUERY_DIR="../../queries"

# Define Trino command with host and port
TRINO_COMMAND="./../../trino $TRINO_HOST:$TRINO_PORT"

# Create or clear the results directory
RESULTS_DIR="query_results"
#mkdir -p "$RESULTS_DIR"

datetime=$(date +"%Y%m%d_%H%M")

# Create CSV file for results
CSV_FILE="$RESULTS_DIR/queries_exec_plan_$datetime.csv"
echo "query,postgresql_run1,cassandra_run1,postgresql_run2,cassandra_run2" > "$CSV_FILE"

# Queries to run
#QUERIES=("001" "007" "008" "009" "013" "017" "019" "024" "025" "026" "027" "029" "034" "036" "039" "040" "043" "046" "047" "048" "050" "053" "054" "057" "059" "061" "062" "063" "064" "068" "073" "079" "084" "085" "088" "089" "090" "091" "093" "096" "099")
QUERIES=("003" "004" "007" "009" "014" "018" "022" "024" "025" "028" "035" "038" "039" "049" "055" "056" "062" "064" "066" "071" "075" "078" "084" "086" "088" "090" "091")
# QUERIES=("022")

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
    postgresql_run1_duration=""
    cassandra_run1_duration=""
    postgresql_run2_duration=""
    cassandra_run2_duration=""

    for db in "${DATABASES[@]}"; do

        # Execute the query 2 times for each database
        for i in {1..2}; do

            # Define the full query with schema
            FULL_QUERY="USE $db.tpcds; $QUERY"

            echo "Running $query_file for $db (Run $i)..."

            # Execute the query in Trino
            $TRINO_COMMAND --execute "$FULL_QUERY" > /dev/null

            # Calculate the duration in seconds
            duration_query="SELECT date_diff('millisecond', created, \"end\") AS duration FROM system.runtime.queries ORDER BY created DESC OFFSET 1 LIMIT 1;"
            duration=$($TRINO_COMMAND --execute "$duration_query")

            # Extract and format the duration
            duration_striped="${duration:1:-1}"

            formatted_duration=$(format_duration "$duration_striped")

            # Store the duration in the appropriate variable based on the run
            case "$i" in
                1)
                    if [ "$db" == "postgresql" ]; then
                        postgresql_run1_duration="$formatted_duration"
                    elif [ "$db" == "cassandra" ]; then
                        cassandra_run1_duration="$formatted_duration"
                    fi
                    ;;
                2)
                    if [ "$db" == "postgresql" ]; then
                        postgresql_run2_duration="$formatted_duration"
                    elif [ "$db" == "cassandra" ]; then
                        cassandra_run2_duration="$formatted_duration"
                    fi
                    ;;
            esac
        done
    done

    # Save query and durations to results CSV file
    echo "$(basename "$query_file" .sql),$postgresql_run1_duration,$cassandra_run1_duration,$postgresql_run2_duration,$cassandra_run2_duration" >> "$CSV_FILE"
done
