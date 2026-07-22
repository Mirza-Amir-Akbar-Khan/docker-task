#!/bin/bash
set -e

# Source the image info file again
source image_info.env

echo "Starting the new Docker container..."

# Run the new container, mapping host port 80 to container port 80[cite: 3]
docker run -d --name my-app -p 80:80 $IMAGE_URI