#!/bin/bash
set -e

# ===============================================================
# Docker Network Creation Script (Overlay with Optional IP Range)
#
# Usage:
#   ./create-network.sh [path_to_env_file]
#
# Environment variables (from .env or passed via shell):
#   NETWORK_NAME    = Name of the Docker network (required)
#   NETWORK_SUBNET  = Subnet in CIDR format (e.g., 172.18.0.0/16) (required)
#   NETWORK_IP_RANGE= Optional IP range for dynamic assignment 
#                     (e.g., 172.18.0.128/25). If set, dynamic IPs
#                     will be allocated from this range only.
#
# Examples:
#   ./create-network.sh                # uses .env in current folder
#   ./create-network.sh /path/prod.env # uses env file from custom path
# ===============================================================

# Pick env file (default: .env in current dir)
ENV_FILE="${1:-.env}"

# Load variables from provided env file
if [ -f "$ENV_FILE" ]; then
  export $(grep -v '^#' "$ENV_FILE" | xargs)
else
  echo "Error: Environment file '$ENV_FILE' not found!"
  exit 1
fi

# Validate required variables
if [ -z "$NETWORK_NAME" ] || [ -z "$NETWORK_SUBNET" ]; then
  echo "Error: NETWORK_NAME and NETWORK_SUBNET must be set in $ENV_FILE"
  exit 1
fi

# Check if the network already exists
if docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
  echo "Network $NETWORK_NAME already exists. Skipping creation."
else
  echo "Creating network $NETWORK_NAME with subnet $NETWORK_SUBNET"
  if [ -n "$NETWORK_IP_RANGE" ]; then
    echo "Using IP range: $NETWORK_IP_RANGE"
    docker network create \
      --driver overlay \
      --subnet="$NETWORK_SUBNET" \
      --ip-range="$NETWORK_IP_RANGE" \
      --attachable \
      "$NETWORK_NAME"
  else
    docker network create \
      --driver overlay \
      --subnet="$NETWORK_SUBNET" \
      --attachable \
      "$NETWORK_NAME"
  fi
fi


# Network settings
#NETWORK_NAME=my_shared_network
#NETWORK_SUBNET=172.18.0.0/16
#NETWORK_IP_RANGE=172.18.0.128/25
