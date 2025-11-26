# ==================== Frontend Build Stage ====================
FROM node:22-alpine AS frontend-builder

WORKDIR /app/frontend

# Copy frontend dependencies
COPY frontend/package.json frontend/pnpm-lock.yaml ./

# Install pnpm and dependencies
RUN npm install -g pnpm && \
    pnpm install --frozen-lockfile

# Copy frontend source code
COPY frontend/ .

# Build frontend
RUN pnpm build

# ==================== Backend Build Stage ====================
FROM python:3.11-slim AS backend-builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Copy Python project files
COPY pyproject.toml uv.lock ./

# Install Python dependencies using uv
RUN /root/.local/bin/uv sync --no-dev --no-editable

# ==================== Runtime Stage ====================
FROM python:3.11-slim

WORKDIR /app

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy Python virtual environment from builder
COPY --from=backend-builder /app/.venv /app/.venv

# Copy backend source code
COPY backend/ ./backend/

# Copy frontend build output
COPY --from=frontend-builder /app/frontend/dist ./frontend/dist

# Create necessary directories for runtime
RUN mkdir -p output history

# Set environment variables
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Create a non-root user for security (optional but recommended)
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:12398/api/health', timeout=5)" || exit 1

# Expose port
EXPOSE 12398

# Run Flask application
CMD ["python", "-m", "flask", "run", "--host=0.0.0.0"]
