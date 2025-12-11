# Step 1: Environment Setup

#### I use django rest framework 
#### IDE is Vs code
#### I also use Git version control



# Step 2: Database Design with ChatGPT

###### SQL commands to set up the `users` and `profiles` tables.

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    age INTEGER,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    bio TEXT,
    profile_picture_url VARCHAR(255),
    social_links JSONB,
    CONSTRAINT fk_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);


# Step 3: Boilerplate, project structure, database models and CRUD logic with GEMINI

##### Here project's basic structure

/WORKSPACE/project$ tree 
.
├── apis
│   ├── admin.py
│   ├── apps.py
│   ├── __init__.py
│   ├── migrations
│   │   └── __init__.py
│   ├── models.py
│   ├── tests.py
│   ├── urls.py
│   └── views.py
├── config
│   ├── asgi.py
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── manage.py
├── Pipfile
└── README.md


##### AND the database models 

from django.db import models

class User(models.Model):
    # Standard fields
    name = models.CharField(max_length=100)
    email = models.EmailField(max_length=255, unique=True)
    age = models.PositiveIntegerField(null=True, blank=True)
    
    # Timestamps
    createdAt = models.DateTimeField(auto_now_add=True)
    updatedAt = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name

class Profile(models.Model):
    user = models.OneToOneField(
        User, 
        on_delete=models.CASCADE, 
        related_name='profile'
    )
    
    bio = models.TextField(blank=True)
    profile_picture_url = models.URLField(max_length=255, blank=True)
    social_links = models.JSONField(default=dict, blank=True)

    def __str__(self):
        return f"{self.user.name}'s Profile"


##### CRUD logic will be implemented (with GEMINI) in these files:

**serializers.py**
**views.py** 


# Step 4: API Development with GEMINI

#### In serializers.py

from rest_framework import serializers
from .models import User, Profile

class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ['id', 'user', 'bio', 'profile_picture_url', 'social_links']
        
class UserSerializer(serializers.ModelSerializer):
    profile = ProfileSerializer(read_only=True)

    class Meta:
        model = User
        fields = ['id', 'name', 'email', 'age', 'profile', 'createdAt', 'updatedAt']
        read_only_fields = ['createdAt', 'updatedAt']

#### In views.py
from rest_framework import viewsets
from .models import User, Profile
from .serializers import UserSerializer, ProfileSerializer

###### User ViewSet (CRUD for User model)
class UserViewSet(viewsets.ModelViewSet):
    """
    Provides CRUD operations for the User model.
    GET /users/       (List Users)
    POST /users/      (Create User)
    GET /users/{pk}/  (Retrieve User)
    PUT/PATCH /users/{pk}/ (Update User)
    DELETE /users/{pk}/ (Delete User)
    """
    queryset = User.objects.all().order_by('-createdAt')
    serializer_class = UserSerializer

###### Profile ViewSet (CRUD for Profile model)
class ProfileViewSet(viewsets.ModelViewSet):
    """
    Provides CRUD operations for the Profile model.
    """
    queryset = Profile.objects.all()
    serializer_class = ProfileSerializer


# Step 5: Data Validation with CLAUDE AI

