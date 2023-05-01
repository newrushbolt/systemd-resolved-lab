#! /usr/bin/env bash

# Clean old artifacts
docker-compose down
rm -fr results

# Run the lab
mkdir results
docker-compose up -d;sleep 3

# Define test commands
CLIENT_RESOLVECTL_COMMAND='resolvectl query registry.company.com > /client/resolvectl.result 2>&1'
CLIENT_DIG_COMMAND='dig registry.company.com > /client/dig.result 2>&1'
CLIENT_CURL_COMMAND='curl --no-progress-meter registry.company.com > /client/curl.result 2>&1'

# Run the tests
CLIENTS=(fc36_no_soa fc36 ubuntu2204)
for CLIENT in ${CLIENTS[@]}; do
    CLIENT_CONTAINER="resolved_lab-${CLIENT}_client-1"
    docker exec -it $CLIENT_CONTAINER sh -c "$CLIENT_RESOLVECTL_COMMAND"
    docker exec -it $CLIENT_CONTAINER sh -c "$CLIENT_DIG_COMMAND"
    docker exec -it $CLIENT_CONTAINER sh -c "$CLIENT_CURL_COMMAND"
done

# Stop the lab
docker-compose down
