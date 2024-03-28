#!/bin/bash

# Your Docker Hub username
DOCKER_USERNAME="gaskin23"

# File to track the version of each service
VERSION_TRACKER="version_tracker.txt"

# List of all services
services=(
  "adservice"
  "checkoutservice"
  "cartservice"
  "currencyservice"
  "emailservice"
  "frontend"
  "loadgenerator"
  "paymentservice"
  "productcatalogservice"
  "recommendationservice"
  "shippingservice"
)

# Initialize or update the version tracker file
if [ ! -f "$VERSION_TRACKER" ]; then
  touch "$VERSION_TRACKER"
fi

# Loop through each service, increment version, tag it, and push it
for service in "${services[@]}"; do
  echo "Processing $service..."

  # Extract the current version for the service, defaulting to 0 if not set
  current_version=$(grep "^$service:" "$VERSION_TRACKER" | cut -d':' -f2)
  if [ -z "$current_version" ]; then
    current_version=0
  fi

  # Increment the version
  new_version=$(echo "$current_version + 1.0" | bc)

  # Update the tracker file
  grep -v "^$service:" "$VERSION_TRACKER" > tmpfile && mv tmpfile "$VERSION_TRACKER"
  echo "$service:$new_version" >> "$VERSION_TRACKER"

  # Tag the image with the new version
  docker tag $service:latest $DOCKER_USERNAME/$service:$new_version
  
  # Push the image to Docker Hub
  docker push $DOCKER_USERNAME/$service:$new_version

  echo "$service has been tagged with version $new_version and pushed to Docker Hub."
done

echo "All images have been pushed to Docker Hub with updated versions."