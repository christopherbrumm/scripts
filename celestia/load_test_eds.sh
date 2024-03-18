#!/bin/bash

# Check if CELESTIA_NODE_AUTH_TOKEN is set
if [ -z "$CELESTIA_NODE_AUTH_TOKEN" ]; then
    echo "Error: CELESTIA_NODE_AUTH_TOKEN is not set."
    exit 1
fi

# Check if port and start_height are provided as arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <port> <start_height>"
    exit 1
fi

port=$1
start_height=$2

counter=0

while true; do
    key=$(($start_height + $counter))
    start_time=$(date +%s.%N)
    response=$(curl -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $CELESTIA_NODE_AUTH_TOKEN" \
        -d "{\"id\": 1, \"jsonrpc\": \"2.0\", \"method\": \"header.GetByHeight\", \"params\": [ $(($key)) ] }" \
        "127.0.0.1:$port" > res.json)
    echo "Executed header.GetByHeight"

    jq -r '.result' res.json > header.json

    curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $CELESTIA_NODE_AUTH_TOKEN" -d '{
        "id": 1,
        "jsonrpc": "2.0",
        "method": "share.GetEDS",
        "params": ['"$(cat header.json)"']
    }' "127.0.0.1:$port" > eds.json

    # Query EDS with extracted header
   edsResponse=$(head -n 5 eds.json)

    end_time=$(date +%s.%N)
    duration=$(echo "$end_time - $start_time" | bc)
    echo "Key: $key | Duration: $duration seconds | Response: $edsResponse"

    ((counter++))
done