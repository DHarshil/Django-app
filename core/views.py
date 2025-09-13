from django.http import JsonResponse, HttpResponse
from . import health

def index(request):
    return HttpResponse("Django Kubernetes Practice App — OK")

def startup(request):
    status = 200 if health.startup_ok() else 500
    return JsonResponse({"startup": "ok" if status == 200 else "fail"}, status=status)

def live(request):
    status = 200 if health.is_alive() else 500
    return JsonResponse({"live": "ok" if status == 200 else "fail"}, status=status)

def ready(request):
    ok = health.is_ready()
    return JsonResponse({"ready": "ok" if ok else "not-ready"}, status=200 if ok else 503)
