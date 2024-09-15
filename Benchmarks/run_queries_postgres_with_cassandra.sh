#!/bin/bash

# Description:
# In our earlier benchmarks we noticed that Cassandra outperforms PostgreSQL mostly on queries that perform aggregations 
# on the largest tables (store_sales, catalog_sales, inventory and web_sales) and that are not too complex.
# This script executes those queries and some complex queries that are not too fast on neihter of the databases. 
# In these queries, we request catalog_sales, store_returns, inventory and/or web_sales from Cassandra and the rest from PostgreSQL.
#
# In the total the queries run in this script are the following:
#
# Queries: 3, 7, 9, 14, 17, 18, 19, 22, 23, 25, 26, 29, 42, 49, 50, 55, 75, 77
#
# The output times are to be compared with the previous query run to determine if any gain is seen.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ../.env

# List of databases
DATABASES=("postgresql")

CASSANDRA_TABLES=(
  "store_sales"         # 3 gb
  "catalog_sales"       # 2.3 gb
  "inventory"           # 1.6 gb
  "web_sales"           # 1.2 gb 
)

# Directory containing SQL queries
QUERY_DIR="../../queries"

Queries=(3 7 9 14 17 18 19 22 23 25 26 29 42 49 50 55 75 77)

# Define Trino command with host and port
TRINO_COMMAND="./../../trino $TRINO_HOST:$TRINO_PORT"

RESULTS_DIR="query_results"

datetime=$(date +"%Y%m%d_%H%M")

# Create CSV file for results
CSV_FILE="$RESULTS_DIR/tpcds_queries_pg_with_cass_$datetime.csv"
echo "query,run1,run2" > "$CSV_FILE"

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

for query in "${Queries[@]}"; do
    formatted_query=$(printf "%03d" "$query")

    query_file=$QUERY_DIR/query$formatted_query.sql
    tmp_query_file=$QUERY_DIR/query${formatted_query}_tmp.sql

    # Make a copy of the original SQL file
    cp $query_file $tmp_query_file

    # Loop through each table and replace in the copied SQL file
    for table in "${CASSANDRA_TABLES[@]}"; do
        sed -i "s/\b${table}\b/cassandra.tpcds.${table}/g" $tmp_query_file
    done

    # Extract the SQL query from the file
    QUERY=$(cat "$tmp_query_file")

    # Initialize variables for storing durations
    run1_duration=""
    run2_duration=""

    for db in "${DATABASES[@]}"; do

        # Execute the query 2 times
        for i in {1..2}; do

            # Define the full query with schema
            FULL_QUERY="USE $db.tpcds; $QUERY"

            echo "Running $query_file for $db with Cassandra (Run $i)..."
        
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
                    run1_duration="$formatted_duration"
                    ;;
                2)
                    run2_duration="$formatted_duration"
                    ;;
            esac
        done
    done

    # Save query and durations to results CSV file
    echo "$(basename "$query_file" .sql),$run1_duration,$run2_duration" >> "$CSV_FILE"

    rm $tmp_query_file
done 