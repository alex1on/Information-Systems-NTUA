#!/bin/bash

#### We will test the retrival speed (SELECT statements on the tables). 
#### Each table will follow the same process.
# 1. Load the data to Redis
# 2. Perform the following queries. SELECT *, SELECT count(*), SELECT a random record of that table.
# 3. We will test only the tables that are less than 512MB (as we tested the store_returns table and was considerably slower on Redis than PostgreSQL and Cassandra). 
# 4. Test if loading more data on the Redis Server impacts negatively the performance. (We will add a dummy table of half a GB to see if there is a change in performance).
#    We will test only the tables that we chose from the start (i.e less than 512MB).

## TODO: Maybe add a join query ? 
## TODO: Automate the random record - Maybe add a 10 step check and consider the average time of retrieval ? 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ../.env

REDIS_DIR="../Databases/Redis"

# Create or clear the results directory
RESULTS_DIR="query_results_redis"
mkdir -p "$RESULTS_DIR"

datetime=$(date +"%Y%m%d_%H%M")

CSV_FILE="$RESULTS_DIR/redis_queries_bench_avg_$datetime.csv"
echo "query,run,postgresql_avg,cassandra_avg,redis_avg" > "$CSV_FILE"

# Define Trino command with host and port
TRINO_COMMAND="./../../trino $TRINO_HOST:$TRINO_PORT"

# List of databases
DATABASES=("postgresql" "cassandra" "redis")

TEST_TABLES=(
  "dbgen_version"               # 4 kb
  "date_dim"                    # 9.8 mb
  "ship_mode"                   # 4 kb
  "warehouse"                   # 4 kb
  "web_site"                    # 12 kb
  "web_page"                    # 16 kb
  "income_band"                 # 4 kb
  "call_center"                 # 8 kb
  "reason"                      # 4 kb
  "item"                        # 23 mb
  "promotion"                   # 56 kb 
  "customer_address"            # 22 mb
  "customer_demographics"       # 76 mb
  "household_demographics"      # 144 kb
  "store"                       # 24 kb
  "time_dim"                    # 4.8 kb
  #"inventory"                  # 1,6 gb
  "catalog_page"                # 1.6 mb
  "customer"                    # 52 mb
  #"web_sales"                  # 1.2 gb
  "web_returns"                 # 78 mb
  #"store_sales"                # 3 gb
  "store_returns"               # 256 mb
  #"catalog_sales"              # 2.3 gb
  "catalog_returns"             # 168 mb    
)

BASE_QUERIES=(
    "SELECT * FROM"
    "SELECT count(*) FROM"
    "SELECT * FROM"
)


# Initialize variables to store total durations for each database and query type
declare -A postgresql_total_duration
declare -A cassandra_total_duration
declare -A redis_total_duration

for table in "${TEST_TABLES[@]}"; do
    for ((i=0; i<${#BASE_QUERIES[@]}; i++)); do
        postgresql_total_duration["$table,$i,1"]=0
        postgresql_total_duration["$table,$i,2"]=0
        cassandra_total_duration["$table,$i,1"]=0
        cassandra_total_duration["$table,$i,2"]=0
        redis_total_duration["$table,$i,1"]=0
        redis_total_duration["$table,$i,2"]=0
    done
done


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

# 23/02/2024 - alex1on
# Change script so that each query is run for all the tables and not for each table to be run all queries
# So we can measure the cache impact on the results of the previous tests.
for bench in {1..10}; do
  CSV_FILE_BENCH="$RESULTS_DIR/redis_queries_bench${bench}_$datetime.csv"
  echo "query,postgresql_run1,cassandra_run1,redis_run1,postgresql_run2,cassandra_run2,redis_run2" > "$CSV_FILE_BENCH"

  echo "########## BENCH $bench ##########"
  for ((i=0; i<${#BASE_QUERIES[@]}; i++)); do
    for table in "${TEST_TABLES[@]}"; do  
      pk=$(python3 $REDIS_DIR/utils/prep_bench_table.py ${table} --cleanup=false | tee /dev/tty | sed -n '2p')
      # Initialize variables for storing durations
      postgresql_run1_duration=""
      cassandra_run1_duration=""
      redis_run1_duration=""
      postgresql_run2_duration=""
      cassandra_run2_duration=""
      redis_run2_duration=""

      BASE_QUERY="${BASE_QUERIES[$i]}"
      QUERY="$BASE_QUERY $table"

      if [ $i -eq 2 ]; then
          QUERY="$BASE_QUERY $table WHERE $pk"
      fi

      FULL_QUERY=""      
      # Repeat the same queries 2 times so we can see the impact of caching. 
      for run in {1..2}; do 
        echo "### RUN $run ###"
        #echo "### RUN $run ###" >> $RESULTS_FILE
        for db in "${DATABASES[@]}"; do
          FULL_QUERY="USE $db.tpcds; $QUERY"
          echo "Running '$FULL_QUERY' for $db..."

          # Execute the query in trino
          $TRINO_COMMAND --execute "$FULL_QUERY" > /dev/null

          # Calculate the duration in seconds
          duration_query="SELECT date_diff('millisecond', created, \"end\") AS duration FROM system.runtime.queries ORDER BY created DESC OFFSET 1 LIMIT 1;"
          duration=$($TRINO_COMMAND --execute "$duration_query")

          # Extract and format the duration
          duration_striped="${duration:1:-1}"

          formatted_duration=$(format_duration "$duration_striped")

          case "$run" in
              1)
                  if [ "$db" == "postgresql" ]; then
                      postgresql_run1_duration="$formatted_duration"
                  elif [ "$db" == "cassandra" ]; then
                      cassandra_run1_duration="$formatted_duration"
                  elif [ "$db" == "redis" ]; then
                      redis_run1_duration="$formatted_duration"
                  fi
                  ;;
              2)
                  if [ "$db" == "postgresql" ]; then
                      postgresql_run2_duration="$formatted_duration"
                  elif [ "$db" == "cassandra" ]; then
                      cassandra_run2_duration="$formatted_duration"
                  elif [ "$db" == "redis" ]; then
                      redis_run2_duration="$formatted_duration"                
                  fi
                  ;;
          esac

          # Update total durations
          case "$db" in
              "postgresql")
                  echo $((postgresql_total_duration["$table,$i,$run"] + duration_striped))
                  postgresql_total_duration["$table,$i,$run"]=$((postgresql_total_duration["$table,$i,$run"] + duration_striped))
                  ;;
              "cassandra")
                  echo $((cassandra_total_duration["$table,$i,$run"] + duration_striped))
                  cassandra_total_duration["$table,$i,$run"]=$((cassandra_total_duration["$table,$i,$run"] + duration_striped))
                  ;;
              "redis")
                  echo $((redis_total_duration["$table,$i,$run"] + duration_striped))
                  redis_total_duration["$table,$i,$run"]=$((redis_total_duration["$table,$i,$run"] + duration_striped))
                  ;;
          esac
        done
      done
      # Save query and durations to results CSV file
      echo "${table}_v$i,$postgresql_run1_duration,$cassandra_run1_duration,$redis_run1_duration,$postgresql_run2_duration,$cassandra_run2_duration,$redis_run2_duration" >> "$CSV_FILE_BENCH"
  
      python3 ../Databases/Redis/utils/flush_redis.py
    done
  done
done

# Calculate averages and write to CSV
for table in "${TEST_TABLES[@]}"; do
    for ((i=0; i<${#BASE_QUERIES[@]}; i++)); do
        for run in {1..2}; do
            echo $((postgresql_total_duration["$table,$i,$run"]))
            postgresql_avg_duration=$((postgresql_total_duration["$table,$i,$run"] / 10)) 
            echo $postgresql_avg_duration
            cassandra_avg_duration=$((cassandra_total_duration["$table,$i,$run"] / 10))
            redis_avg_duration=$((redis_total_duration["$table,$i,$run"] / 10))

            pg_avg_formatted_dur=$(format_duration "$postgresql_avg_duration")
            echo $pg_avg_formatted_dur
            cas_avg_formatted_dur=$(format_duration "$cassandra_avg_duration")
            redis_avg_formatted_dur=$(format_duration "$redis_avg_duration")

            # Write to CSV
            echo "${table}_v$i,Run$run,$pg_avg_formatted_dur,$cas_avg_formatted_dur,$redis_avg_formatted_dur" >> "$CSV_FILE"
        done
    done
done
