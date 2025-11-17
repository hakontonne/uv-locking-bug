# Minimal Dockerfile to reproduce uv workspace + --locked behavior
# Mirrors the official uv Dockerfile template and your local.Dockerfile/base.Dockerfile flow

FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

WORKDIR /app

# 1) Pre-resolve dependencies using the lock and project file only (no source tree)
#    This mirrors:
#    uv sync --no-install-project --no-dev --locked
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock,ro \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --no-install-project --no-dev --locked

# 2) Copy the full source code
COPY . /app

# 3) Install all workspace packages into the environment, still honoring the lock
#    Mirrors:
#    uv sync --locked --no-dev --all-packages
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --no-dev --all-packages

# Tiny runtime check (optional)
CMD ["python", "-c", "import examplelib; print(examplelib.add(2,3))"]
