#!/bin/bash

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

# Loop through each service
for service in "${services[@]}"; do
  echo "Checking for image: $service"

  # Check if the image already exists
  if docker images | grep -q "^$service "; then
    echo "Image $service already exists, skipping..."
  else
    echo "Building Docker image for $service..."

    # Special case for cartservice, which has the Dockerfile in the src folder
    if [ "$service" == "cartservice" ]; then
      (cd "$service/src" && docker build -t "$service" .)
    else
      # Build the Docker image with the service name as its tag
      (cd "$service" && docker build -t "$service" .)
    fi
  fi
done