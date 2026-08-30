# DeepTutor with Docling Support

An automated, containerized build of [DeepTutor](https://github.com/hkuds/deeptutor) bundled with the [Docling](https://github.com/docling-project/docling) document parsing engine and persistent model caching.

## ✨ Features

- **Up-to-date with Upstream**: Automatically tracks and builds against `ghcr.io/hkuds/deeptutor:latest`.
- **Docling Engine Installed**: Includes `deeptutor[parse-docling]` for rich PDF, table, and OCR extraction.
- **Persistent AI Model Storage**: Configured to store all Docling, Hugging Face, and PyTorch model weights inside the `/app/data/cache` persistent volume so they survive container reboots and rebuilds.
- **Smart CI/CD**: Daily GitHub Actions check for new upstream releases by SHA256 digest and only triggers a rebuild when upstream pushes updates.

---

## 🚀 Quick Start

### Option A: Docker CLI

```bash
docker run -d \
  --name deeptutor-docling \
  -p 3782:3782 \
  -p 8001:8001 \
  -v ./data:/app/data \
  <your-dockerhub-username>/deeptutor-docling:latest
```

### Option B: Docker Compose

Create a `docker-compose.yml`:

```yaml
services:
  deeptutor:
    image: <your-dockerhub-username>/deeptutor-docling:latest
    container_name: deeptutor-docling
    restart: unless-stopped
    ports:
      - "3782:3782"  # Frontend (Web UI)
      - "8001:8001"  # Backend (FastAPI)
    volumes:
      - ./data:/app/data
```

Start the container:
```bash
docker compose up -d
```

Access the UI at **`http://localhost:3782`** (Backend API at **`http://localhost:8001`**).

---

## 💾 Model Caching Architecture

Models downloaded by Docling and Hugging Face are routed into the mounted `/app/data` volume:

| Component | Path in Container | Path on Host |
| :--- | :--- | :--- |
| **Docling Models & Artifacts** | `/app/data/cache/docling/models` | `./data/cache/docling/models` |
| **Hugging Face Hub** | `/app/data/cache/huggingface/hub` | `./data/cache/huggingface/hub` |
| **PyTorch Cache** | `/app/data/cache/torch` | `./data/cache/torch` |

---

## ⚙️ GitHub Actions Setup

To enable automated Docker Hub publishing for your repository:

1. Go to repository **Settings** → **Secrets and variables** → **Actions**.
2. Add the following secrets:
   - `DOCKERHUB_USERNAME`: Your Docker Hub username.
   - `DOCKERHUB_TOKEN`: Personal Access Token from Docker Hub (**Account Settings** → **Security**).
