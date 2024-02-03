#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Bash Script to run the load data redis python file
python_script="load_data_redis.py"
python3 "$script_dir/$python_script"