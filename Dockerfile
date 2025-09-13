# Minimal production-ready image
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# System deps (none required for sqlite/gunicorn)
RUN pip install --no-cache-dir --upgrade pip

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Expose app port
EXPOSE 8000

# Set defaults (override via env)
ENV DJANGO_SETTINGS_MODULE=config.settings

# Collect static (no-op if none)
RUN python manage.py collectstatic --noinput || true

CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000"]
