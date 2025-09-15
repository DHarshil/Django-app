FROM python:3.12-slim-bookworm AS builder

WORKDIR /app

RUN pip install --no-cache-dir --upgrade pip

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV DJANGO_SETTINGS_MODULE=config.settings

RUN python manage.py collectstatic --noinput || true

FROM python:3.12-slim-bookworm AS runner

WORKDIR /app

COPY --from=builder /usr/local /usr/local

COPY --from=builder /app /app

ENV DJANGO_SETTINGS_MODULE=config.settings
ENV PORT=8000
EXPOSE $PORT

CMD ["gunicorn", "config.wsgi:application"]