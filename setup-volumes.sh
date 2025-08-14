#!/bin/bash
set -e

# ----------------------------
volumes
# ----------------------------

VOLUMES=(
  "prometheus_data"
  "grafana_data"
  "loki_data"
  "portainer_data"
  "registry_data"
  "vault_data"
)

# ----------------------------
# Create volumes if they don't exist
# ----------------------------
for vol in "${VOLUMES[@]}"; do
  if ! docker volume inspect "$vol" >/dev/null 2>&1; then
    echo "Creating volume: $vol"
    docker volume create "$vol"
  else
    echo "Volume $vol already exists"
  fi
done

echo "✅ Network and volumes setup complete."
