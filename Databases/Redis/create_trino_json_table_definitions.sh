#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Bash Script to run the json_schema python file
# It creates the table definiition files for redis tables in trino
python_script="json_schema.py"
python3 "$script_dir/utils/$python_script"