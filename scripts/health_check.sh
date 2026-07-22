#!/bin/bash

echo "Waiting 5 seconds for the Nginx container to initialize..."
sleep 5

echo "Performing health check on port 80..."

# Perform a silent HTTP request to localhost
if curl -s -f http://localhost:80/ > /dev/null; then
    echo "Health check passed! The new container is running successfully."
    
    # The deployment is successful, so we can clean up the old container
    docker rm -f my-app-old || true
    exit 0
else
    echo "Health check failed! The container did not respond with a successful HTTP status."
    
    # Exit with a non-zero status to force CodeDeploy to fail and initiate a rollback
    exit 1
fi