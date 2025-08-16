#!/bin/bash

PORTAINER_URL="https://ip-2-56-212-253-123420.vps.hosted-by-mvps.net:92/api"
PORTAINER_USERNAME=""
PORTAINER_PASSWORD=""
IMAGE="ip-2-56-212-253-123420.vps.hosted-by-mvps.net:5000/anotherapp"
CONTAINER_NAME="myapp"
ENDPOINT_ID=3

echo "[1/3] Getting JWT..."
TOKEN=$(curl -s -X POST "$PORTAINER_URL/auth" \
  -H "Content-Type: application/json" \
  -d "{\"Username\":\"$PORTAINER_USERNAME\",\"Password\":\"$PORTAINER_PASSWORD\"}" \
  | grep -o '"jwt":"[^"]*"' | sed 's/"jwt":"//;s/"//')

if [ -z "$TOKEN" ]; then
  echo "❌ Failed to get JWT token"
  exit 1
fi

echo "[2/3] Pulling latest image..."
curl -s -X POST "$PORTAINER_URL/endpoints/$ENDPOINT_ID/docker/images/create?fromImage=$IMAGE&tag=latest" \
  -H "Authorization: Bearer $TOKEN"

echo "[3/3] Restarting container..."
curl -s -X POST "$PORTAINER_URL/endpoints/$ENDPOINT_ID/docker/containers/$CONTAINER_NAME/restart?signal=SIGTERM" \
  -H "Authorization: Bearer $TOKEN"

echo "✅ Done."
