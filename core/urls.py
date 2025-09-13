from django.urls import path
from . import views

urlpatterns = [
    path("", views.index, name="index"),
    path("startup", views.startup, name="startup"),
    path("live", views.live, name="live"),
    path("ready", views.ready, name="ready"),
]
