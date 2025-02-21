# First stage: Builder
FROM python:3.11-buster AS builder
WORKDIR /app

# Copy application files
COPY . .

# Install Poetry and dependencies
RUN pip install --upgrade pip && pip install poetry
RUN poetry config virtualenvs.create false && poetry install --no-root --no-interaction --no-ansi

# Final stage: Application runtime
FROM python:3.11-buster AS prod
WORKDIR /app
COPY --from=builder /app /app

# Copy application files
COPY . .

# Expose port 8000 for FastAPI
EXPOSE 8000

# Set the entrypoint and start command
ENV PATH=/app/.venv/bin:$PATH
CMD ["uvicorn", "cc_compose.server:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]
