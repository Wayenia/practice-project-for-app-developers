from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import UserViewSet, ProfileViewSet

# Create a router instance
router = DefaultRouter()

# Register ViewSets with the router. 
router.register(r'users', UserViewSet)
router.register(r'profiles', ProfileViewSet)

urlpatterns = [
    path('api/', include(router.urls)),
]