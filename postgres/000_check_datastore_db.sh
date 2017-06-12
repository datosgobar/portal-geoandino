#!/bin/bash
set -e

if [ ! "$DATASTORE_DB" ]
then
    echo "Missing DATASTORE_DB variable";
    exit 1;
fi