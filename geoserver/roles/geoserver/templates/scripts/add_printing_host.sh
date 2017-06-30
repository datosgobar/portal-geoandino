#!/bin/bash

HOST_IP="$1"

usage() {
    echo "Usage: `basename $0` YOUR_IP" >&2
}

if [[ -z "$HOST_IP" ]]; then
    usage;
    exit 1;
fi

sed -i "/hosts:/a\  - !dnsMatch\n    host: $HOST_IP\n    port: 80" {{ printing_xml_file }}
