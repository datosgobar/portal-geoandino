#!/bin/bash

set -e;

{{ bins_dir }}wait-for-it.sh {{ database_host }}:{{ database_port }} -- echo "The database is up"