# Docker Volume Setup Script

This document explains how to use the Docker volume setup script for creating persistent volumes in a Docker Swarm environment.

---

## **Purpose**

The script:

* Creates Docker volumes defined in a `.env` file.
* Ensures volumes are **idempotent** (won’t recreate existing volumes).
* Allows for easy configuration and maintenance.
* Supports **newline-separated lists** for better readability.

---

## **Files**

### 1. `.env`

Define the list of volumes:

```env
VOLUMES_LIST="
prometheus_data
grafana_data
loki_data
portainer_data
registry_data
vault_data
"
```

* Each volume name must be on a separate line.
* Empty lines are ignored.

---

### 2. `setup-volumes.sh`

Bash script to create volumes with optional `.env` path:

```bash
#!/bin/bash
set -e

# Use provided .env path or default to current directory
ENV_FILE=${1:-.env}

if [ -f "$ENV_FILE" ]; then
  export $(grep -v '^#' "$ENV_FILE" | xargs)
else
  echo "$ENV_FILE not found!"
  exit 1
fi

# Read VOLUMES_LIST line by line
while read -r vol; do
  # skip empty lines
  [[ -z "$vol" ]] && continue

  if ! docker volume inspect "$vol" >/dev/null 2>&1; then
    echo "Creating volume: $vol"
    docker volume create "$vol"
  else
    echo "Volume $vol already exists"
  fi
 done <<< "$VOLUMES_LIST"

echo "✅ All volumes are ready."
```

* You can pass a custom `.env` location as an argument:

```bash
bash setup-volumes.sh /path/to/custom/.env
```

* If no argument is provided, it defaults to `.env` in the current directory.

---

## **Usage**

1. Make sure `.env` (or your custom file) and `setup-volumes.sh` are available.
2. Run the script:

```bash
bash setup-volumes.sh
```

* Or with a custom `.env` location:

```bash
bash setup-volumes.sh /path/to/custom/.env
```

* You do **not** need to run `chmod +x` if you use `bash` to execute it.

---

## **Benefits**

* **Idempotent**: Safe to run multiple times.
* **Readable configuration**: Newline-separated volumes are easy to maintain.
* **Flexible**: Easily add/remove volumes by editing `.env`.
* **Swarm-ready**: Works for Docker Swarm multi-stack deployments.

---

## **Tips**

* You can add comments inside the `.env` list using `#`, which will be ignored.
* For automation, you can integrate this script into CI/CD pipelines.
