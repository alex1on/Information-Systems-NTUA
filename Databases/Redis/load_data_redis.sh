#!/bin/bash

# Get the directory of the current script
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Set the directory containing the Python script
python_dir="$script_dir/utils"

# Set the Python script name
python_script="load_data_redis.py"

# Run the Python script with appropriate arguments
python3 "$python_dir/$python_script" "$@"