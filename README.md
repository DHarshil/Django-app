# dj-k8s-practice

A tiny Django app with four routes for Kubernetes probe practice:

- `/` — Index
- `/startup` — for `startupProbe`
- `/live` — for `livenessProbe`
- `/ready` — for `readinessProbe` (optionally delayed via `READINESS_DELAY` env var)

## Quickstart (Local)

```bash
# 1) Build and run with Docker
docker build -t dj-k8s-practice:latest .
docker run --rm -p 8000:8000   -e DJANGO_SECRET_KEY=dev-secret   -e DJANGO_DEBUG=1   -e READINESS_DELAY=0   dj-k8s-practice:latest

# Visit http://localhost:8000/, /startup, /live, /ready
```

Or with docker-compose:

```bash
docker compose up --build
```

## Environment Variables

- `DJANGO_SECRET_KEY` (required in prod) — Django secret key.
- `DJANGO_DEBUG` (`0`/`1`, default `0`)
- `ALLOWED_HOSTS` (comma-separated, default `*`)
- `READINESS_DELAY` (seconds; default `0`). If set (e.g., `30`), `/ready` will return **503** until the delay has passed **since the process started**, useful for practicing readiness probes.

## Kubernetes (manifests in `k8s/`)

1. (Optional) Create a secret for the Django key:
   ```bash
   kubectl apply -f k8s/secret.example.yaml
   ```
   _Edit the base64 value or create your own Secret._

2. Deploy:
   ```bash
   kubectl apply -f k8s/deployment.yaml
   kubectl apply -f k8s/service.yaml
   ```

3. Port-forward the service:
   ```bash
   kubectl port-forward svc/dj-k8s-practice 8000:80
   ```

### Probes configured

- **startupProbe** → GET `/startup`
- **livenessProbe** → GET `/live`
- **readinessProbe** → GET `/ready` (honors `READINESS_DELAY`)

## Dev without Docker

```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
export DJANGO_SECRET_KEY=dev-secret
export DJANGO_DEBUG=1
python manage.py migrate
python manage.py runserver 0.0.0.0:8000
```

## Project Layout

```
dj-k8s-practice/
├── config/
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── core/
│   ├── __init__.py
│   ├── apps.py
│   ├── health.py
│   ├── urls.py
│   └── views.py
├── k8s/
│   ├── deployment.yaml
│   ├── secret.example.yaml
│   └── service.yaml
├── manage.py
├── requirements.txt
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
└── .gitignore
```
