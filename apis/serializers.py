from rest_framework import serializers
from .models import User, Profile
import re

class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ['id', 'user', 'bio', 'profile_picture_url', 'social_links']
    
    def validate_profile_picture_url(self, value):
        """Validate profile picture URL format if provided"""
        if value and not value.startswith(('http://', 'https://')):
            raise serializers.ValidationError("Profile picture URL must start with http:// or https://")
        return value

class UserSerializer(serializers.ModelSerializer):
    profile = ProfileSerializer(read_only=True)
    
    class Meta:
        model = User
        fields = ['id', 'name', 'email', 'age', 'profile', 'createdAt', 'updatedAt']
        read_only_fields = ['createdAt', 'updatedAt']
    
    def validate_name(self, value):
        """
        Validation: Ensure name is a non-empty string
        - Must not be empty or only whitespace
        - Must be a string type
        """
        if not value or not value.strip():
            raise serializers.ValidationError("Name cannot be empty or contain only whitespace.")
        
        if not isinstance(value, str):
            raise serializers.ValidationError("Name must be a string.")
        
        # Optional: Check for minimum length
        if len(value.strip()) < 2:
            raise serializers.ValidationError("Name must be at least 2 characters long.")
        
        return value.strip()
    
    def validate_email(self, value):
        """
        Validation: Ensure email has a valid format
        - Must contain @ symbol
        - Must have valid domain structure
        - Case-insensitive uniqueness check
        """
        if not value:
            raise serializers.ValidationError("Email cannot be empty.")
        
        # Email regex pattern for validation
        email_pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        
        if not re.match(email_pattern, value):
            raise serializers.ValidationError("Enter a valid email address.")
        
        # Check for uniqueness (excluding current instance during updates)
        instance_id = self.instance.id if self.instance else None
        if User.objects.filter(email__iexact=value).exclude(id=instance_id).exists():
            raise serializers.ValidationError("A user with this email already exists.")
        
        return value.lower()
    
    def validate_age(self, value):
        """
        Validation: Ensure age is a numerical value between 1 and 120
        - Must be an integer
        - Must be between 1 and 120 inclusive
        """
        if value is None:
            return value  # Age is optional
        
        if not isinstance(value, int):
            raise serializers.ValidationError("Age must be a numerical value.")
        
        if value < 1 or value > 120:
            raise serializers.ValidationError("Age must be between 1 and 120.")
        
        return value