#!/bin/bash
set -e

# CodeDeploy runs lifecycle scripts from the root of the deployment archive.
# Source the file created by CodeBuild to access the $IMAGE_URI variable.
source image_info.env

# Retrieve the EC2 region using IMDSv2 (AWS Best Practice for metadata)
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" -s)
REGION=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/region)

# Extract the ECR registry URL from the full IMAGE_URI
REGISTRY_URL=$(echo $IMAGE_URI | cut -d'/' -f1)

echo "Logging into Amazon ECR in region $REGION..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $REGISTRY_URL

echo "Pulling the new Docker image: $IMAGE_URI"
docker pull $IMAGE_URI


