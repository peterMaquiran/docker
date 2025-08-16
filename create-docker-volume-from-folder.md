# Copy Local Folder into a Docker Volume

This guide shows how to copy files from a **local folder** into a **Docker volume** using a temporary container.

---

## Command

```bash
docker run --rm   -v $(pwd)/grafana:/from   -v grafana_data:/to   alpine sh -c "cp -r /from/* /to/"
```

---

## How It Works

1. **Temporary Container**  
   The `docker run --rm` command creates a short-lived container that is automatically removed once the copy operation finishes. No leftover containers remain.

2. **Mount Local Folder**  
   `-v $(pwd)/grafana:/from` mounts the local folder `grafana` (from the current working directory) into the container at `/from`.

3. **Mount Docker Volume**  
   `-v grafana_data:/to` mounts the existing Docker volume named `grafana_data` into the container at `/to`.

4. **Lightweight Image**  
   The container uses the `alpine` image, a minimal Linux distribution ideal for small tasks like file copying.

5. **Copy Command**  
   Inside the container, the command `sh -c "cp -r /from/* /to/"` runs, which recursively copies all files from the local directory (`/from`) into the Docker volume (`/to`).

---

## Why Use This?

- **Pre-populate volumes** before starting a container (e.g., add Grafana dashboards).  
- **Migrate configurations** or application data into an existing Docker volume.  
- **Restore backups** from a local directory into a Docker-managed volume.  

---

```bash
docker run -d   -p 3000:3000   -v grafana_data:/var/lib/grafana   grafana/grafana
```

Grafana will load your pre-copied files automatically.
