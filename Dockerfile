# First stage: Builder
FROM python:3.11-buster AS builder
WORKDIR /app

# Install Poetry and dependencies
RUN pip install --upgrade pip && pip install poetry
COPY pyproject.toml poetry.lock ./
RUN poetry config virtualenvs.create false && poetry install --no-root --no-interaction --no-ansi

# Copy application files
COPY . .

# Final stage: Application runtime
FROM python:3.11-buster
WORKDIR /app
COPY --from=builder /app /app

# Ensure the entrypoint script is copied
COPY ./entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Expose port 8000 for FastAPI
EXPOSE 8000

# Set the entrypoint and start command
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["uvicorn", "cc_compose.server:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]
