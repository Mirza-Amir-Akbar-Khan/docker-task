#!/bin/bash
set -e

# Check if a container named 'my-app' exists and is running
if [ -n "$(docker ps -q -f name=my-app)" ]; then
    echo "Stopping the currently running container..."
    docker stop my-app
    
    echo "Renaming old container to 'my-app-old' for a potential rollback..."
    # Remove the previous backup if it exists, then rename the current one
    docker rm -f my-app-old || true
    docker rename my-app my-app-old
else
    echo "No running container named 'my-app' was found. Skipping stop phase."
fi