#!/bin/bash
set -e
 
# CodeDeploy may run lifecycle scripts with a working directory that isn't
# guaranteed to be the deployment archive root. Resolve this script's own
# location instead, then source image_info.env relative to that (it lives
# one level up, at the archive root, alongside the scripts/ folder).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../image_info.env"
 
echo "Starting the new Docker container..."
 
# Run the new container, mapping host port 80 to container port 80
docker run -d --name my-app -p 80:80 $IMAGE_URI
 