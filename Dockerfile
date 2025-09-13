FROM python:3.12-alpine AS builder

WORKDIR /app

RUN pip install --no-cache-dir --upgrade pip

 COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV DJANGO_SETTINGS_MODULE=config.settings

RUN python manage.py collectstatic --noinput || true

FROM python:3.12-alpine AS runner

WORKDIR /app

COPY --from=builder /app /app

ENV DJANGO_SETTINGS_MODULE=config.settings
EXPOSE 8000

CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000"]