# ==============================================================================
# DeepTutor with Docling Document Parsing Engine
# ==============================================================================
# Base: Official upstream latest release of DeepTutor
# Target Architecture: linux/amd64
# ==============================================================================

FROM ghcr.io/hkuds/deeptutor:latest

# Switch to root to configure environment and install packages
USER root

# 1. Set environment variables to route model downloads to persistent storage (/app/data)
ENV DOCLING_ARTIFACTS_PATH=/app/data/cache/docling/models \
    DOCLING_CACHE_DIR=/app/data/cache/docling \
    HF_HOME=/app/data/cache/huggingface \
    HUGGINGFACE_HUB_CACHE=/app/data/cache/huggingface/hub \
    TORCH_HOME=/app/data/cache/torch

# 2. Install optional document parsing engine: Docling via deeptutor extras
RUN pip install --no-cache-dir "deeptutor[parse-docling]"

# 3. Pre-create cache directories and set ownership for deeptutor user (UID: 1000, GID: 1000)
RUN mkdir -p /app/data/cache/docling/models \
             /app/data/cache/huggingface/hub \
             /app/data/cache/torch \
    && chown -R deeptutor:deeptutor /app/data/cache
