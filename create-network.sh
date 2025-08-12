#!/bin/bash
set -e

# Usage: ./create-network.sh /path/to/envfile
ENV_FILE="${1:-.env}"  # Default to .env in current folder if no argument

# Load variables from provided env file
if [ -f "$ENV_FILE" ]; then
  export $(grep -v '^#' "$ENV_FILE" | xargs)
else
  echo "Error: Environment file '$ENV_FILE' not found!"
  exit 1
fi

# Check if the network already exists
if docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
  echo "Network $NETWORK_NAME already exists. Skipping creation."
else
  echo "Creating network $NETWORK_NAME with subnet $NETWORK_SUBNET"
  docker network create \
    --driver overlay \
    --subnet="$NETWORK_SUBNET" \
    --attachable \
    "$NETWORK_NAME"
fi
