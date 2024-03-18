#!/bin/bash

# Check if CELESTIA_NODE_AUTH_TOKEN is set
if [ -z "$CELESTIA_NODE_AUTH_TOKEN" ]; then
    echo "Error: CELESTIA_NODE_AUTH_TOKEN is not set."
    exit 1
fi

# Check if port and start_height are provided as arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <port> <start_height>"
    exit 1
fi

port=$1
start_height=$2

counter=0

while true; do
    key=$(($start_height + $counter))

    # Loop for each of the five requests
    for ((i=1; i<=5; i++)); do
        request_number=$(( ($counter * 5) + $i ))
        start_time=$(date +%s.%N)
        response=$(curl -s -X POST \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $CELESTIA_NODE_AUTH_TOKEN" \
            -d "{\"id\": 1, \"jsonrpc\": \"2.0\", \"method\": \"header.GetByHeight\", \"params\": [ $(($start_height+$counter)) ] }" \
            "127.0.0.1:$port")
        end_time=$(date +%s.%N)
        duration=$(echo "$end_time - $start_time" | bc)
        echo "Key: $key | Request: $i/5 | Duration: $duration seconds | Response: $response"

        # Extract the header data from the previous request
        result=$(echo "$response" | jq -r '.result')

        # Execute another query using the extracted data
        curl -s -X POST \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $CELESTIA_NODE_AUTH_TOKEN" \
            -d "{\"id\": 1, \"jsonrpc\": \"2.0\", \"method\": \"share.GetEDS\", \"params\": [ $(($result)) ] }" \
            "127.0.0.1:$port"
    done

    ((counter++))
done