from rest_framework import viewsets, status
from rest_framework.response import Response
from rest_framework.decorators import action
from .models import User, Profile
from .serializers import UserSerializer, ProfileSerializer

class UserViewSet(viewsets.ModelViewSet):
    """
    Provides CRUD operations for the User model with validation.
    
    Endpoints:
    - GET    /api/users/           (List all users)
    - POST   /api/users/           (Create new user)
    - GET    /api/users/{pk}/      (Retrieve specific user)
    - PUT    /api/users/{pk}/      (Full update user)
    - PATCH  /api/users/{pk}/      (Partial update user)
    - DELETE /api/users/{pk}/      (Delete user)
    
    Validation Rules:
    - name: Non-empty string, minimum 2 characters
    - email: Valid email format, unique
    - age: Integer between 1-120 (optional)
    """
    queryset = User.objects.all().order_by('-createdAt')
    serializer_class = UserSerializer
    
    def create(self, request, *args, **kwargs):
        """Create a new user with validation"""
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(
            serializer.data, 
            status=status.HTTP_201_CREATED, 
            headers=headers
        )
    
    def update(self, request, *args, **kwargs):
        """Update user with validation"""
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def validate_email(self, request):
        """
        Custom endpoint to check if email is available
        GET /api/users/validate_email/?email=test@example.com
        """
        email = request.query_params.get('email', None)
        if not email:
            return Response(
                {'error': 'Email parameter is required'}, 
                status=status.HTTP_400_BAD_REQUEST
            )
        
        exists = User.objects.filter(email__iexact=email).exists()
        return Response({
            'email': email,
            'available': not exists
        })


class ProfileViewSet(viewsets.ModelViewSet):
    """
    Provides CRUD operations for the Profile model.
    
    Endpoints:
    - GET    /api/profiles/        (List all profiles)
    - POST   /api/profiles/        (Create new profile)
    - GET    /api/profiles/{pk}/   (Retrieve specific profile)
    - PUT    /api/profiles/{pk}/   (Full update profile)
    - PATCH  /api/profiles/{pk}/   (Partial update profile)
    - DELETE /api/profiles/{pk}/   (Delete profile)
    """
    queryset = Profile.objects.all()
    serializer_class = ProfileSerializer