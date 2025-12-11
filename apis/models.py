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