#!/bin/bash

set -e;

{{ bins_dir }}wait-for-it.sh $POSTGRES_HOST:5432 -- echo "The database is up"