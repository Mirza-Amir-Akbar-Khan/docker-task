#!/bin/bash
set -e
 
# CodeDeploy may run lifecycle scripts with a working directory that isn't
# guaranteed to be the deployment archive root. Resolve this script's own
# location instead, then source image_info.env relative to that (it lives
# one level up, at the archive root, alongside the scripts/ folder).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../image_info.env"
 
# Retrieve the EC2 region using IMDSv2 (AWS Best Practice for metadata)
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" -s)
REGION=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/region)
 
# Extract the ECR registry URL from the full IMAGE_URI
REGISTRY_URL=$(echo $IMAGE_URI | cut -d'/' -f1)
 
echo "Logging into Amazon ECR in region $REGION..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $REGISTRY_URL
 
echo "Pulling the new Docker image: $IMAGE_URI"
docker pull $IMAGE_URI
 