FROM ghcr.io/astral-sh/uv:0.7.22-debian-slim AS builder

# add python3 runtime to the hadoop image (interpreter and minimal venv)
# note that this must be rebuilt anytime packages are updated in pyproject.toml
ENV UV_PYTHON_INSTALL_DIR=/opt/uv-python

WORKDIR /opt/python-runtime

COPY pyproject.toml .
COPY uv.lock .
COPY .python-version .

RUN uv venv --no-cache && uv sync --locked --no-cache

FROM apache/hadoop:3.3.6 AS runtime

COPY --from=builder /opt/python-runtime/.venv /opt/python-runtime/.venv
COPY --from=builder /opt/uv-python /opt/uv-python
