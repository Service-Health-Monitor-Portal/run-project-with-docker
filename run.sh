#!/bin/bash

# Function to create Docker network if it doesn't exist
create_network() {
    if ! docker network ls | grep -q 'service-health-network'; then
        echo 'Creating Docker network: service-health-network'
        docker network create service-health-network
    else
        echo 'Docker network: service-health-network already exists.'
    fi
}

# Function to create Docker volume if it doesn't exist
create_volume() {
    if ! docker volume ls | grep -q 'simulator-logs'; then
        echo 'Creating Docker volume: simulator-logs'
        docker volume create simulator-logs
    else
        echo 'Docker volume: simulator-logs already exists.'
    fi
}

# Function to run Docker containers
run_containers() {
    echo 'Running Health Service Simulator container...'
    docker run -d --name simulator1 --network service-health-network -p 7000:7000 \
        -v simulator-logs:/home miinamagdy/simulator2:test

    echo 'Running Health Service Log Analyzer container...'
    docker run -d --name log-analyzer1 --network service-health-network -p 8080:8080 \
        -v simulator-logs:/home miinamagdy/log-analyzer2:test

    echo 'Running Health Service Frontend container...'
    docker run -d --name service-health-frontend -p 5173:5173 --network service-health-network efraimnabil/health-service_frontend
}

# Function to open the frontend in the default browser
open_browser() {
    open http://localhost:5173
}

# Main script execution
create_network
create_volume
run_containers
open_browser

echo 'All containers are up and running.'


