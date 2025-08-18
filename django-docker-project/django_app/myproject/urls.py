from django.contrib import admin
from django.urls import path
from django.http import HttpResponse

def home(request):
    return HttpResponse("Привіт! Django працює з PostgreSQL та Nginx!")

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', home, name='home'),
]