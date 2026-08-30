# ==============================================================================
# DeepTutor with Docling Document Parsing Engine
# ==============================================================================
# Base: Official upstream latest release of DeepTutor
# Target Architecture: linux/amd64
# ==============================================================================

FROM ghcr.io/hkuds/deeptutor:latest

# Switch to root to configure environment and install packages
USER root

# 1. Install fontconfig (required by docling_parse C++ PDF renderer)
RUN apt-get update && apt-get install -y --no-install-recommends \
    fontconfig \
    && rm -rf /var/lib/apt/lists/*

# 2. Set HOME & XDG paths to /home/deeptutor to prevent docling from accessing /root
ENV HOME=/home/deeptutor \
    XDG_DATA_HOME=/home/deeptutor/.local/share \
    XDG_CONFIG_HOME=/home/deeptutor/.config \
    XDG_CACHE_HOME=/app/data/cache \
    DOCLING_ARTIFACTS_PATH=/app/data/cache/docling/models \
    DOCLING_CACHE_DIR=/app/data/cache/docling \
    HF_HOME=/app/data/cache/huggingface \
    HUGGINGFACE_HUB_CACHE=/app/data/cache/huggingface/hub \
    TORCH_HOME=/app/data/cache/torch

# 3. Install optional document parsing engine: Docling via deeptutor extras
RUN pip install --no-cache-dir "deeptutor[parse-docling]"

# 4. Create home & cache directories and set ownership for deeptutor user (UID: 1000, GID: 1000)
RUN mkdir -p /home/deeptutor/.local/share/fonts \
             /home/deeptutor/.config \
             /app/data/cache/docling/models \
             /app/data/cache/huggingface/hub \
             /app/data/cache/torch \
    && chown -R deeptutor:deeptutor /home/deeptutor /app/data/cache
