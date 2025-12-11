#!/bin/bash
# HTTPie Test Commands for Django API
# Make sure your Django server is running: python manage.py runserver

echo "================================"
echo "Testing User API Endpoints"
echo "================================"

# Test 1: Create a valid user
echo -e "\n[TEST 1] Creating a valid user..."
http POST http://localhost:8000/api/users/ \
  name="John Doe" \
  email="john@example.com" \
  age=30

# Test 2: Try to create user with empty name (should fail)
echo -e "\n[TEST 2] Creating user with empty name (should fail)..."
http POST http://localhost:8000/api/users/ \
  name="" \
  email="empty@example.com" \
  age=25

# Test 3: Try to create user with whitespace-only name (should fail)
echo -e "\n[TEST 3] Creating user with whitespace name (should fail)..."
http POST http://localhost:8000/api/users/ \
  name="   " \
  email="whitespace@example.com" \
  age=25

# Test 4: Try to create user with invalid email (should fail)
echo -e "\n[TEST 4] Creating user with invalid email (should fail)..."
http POST http://localhost:8000/api/users/ \
  name="Invalid Email User" \
  email="notanemail" \
  age=25

# Test 5: Try to create user with age below 1 (should fail)
echo -e "\n[TEST 5] Creating user with age 0 (should fail)..."
http POST http://localhost:8000/api/users/ \
  name="Young User" \
  email="young@example.com" \
  age=0

# Test 6: Try to create user with age above 120 (should fail)
echo -e "\n[TEST 6] Creating user with age 121 (should fail)..."
http POST http://localhost:8000/api/users/ \
  name="Old User" \
  email="old@example.com" \
  age=121

# Test 7: Create user with boundary age values (should succeed)
echo -e "\n[TEST 7] Creating user with age 1 (boundary test)..."
http POST http://localhost:8000/api/users/ \
  name="Baby User" \
  email="baby@example.com" \
  age=1

echo -e "\n[TEST 8] Creating user with age 120 (boundary test)..."
http POST http://localhost:8000/api/users/ \
  name="Senior User" \
  email="senior@example.com" \
  age=120

# Test 9: Create user without age (optional field)
echo -e "\n[TEST 9] Creating user without age (should succeed)..."
http POST http://localhost:8000/api/users/ \
  name="No Age User" \
  email="noage@example.com"

# Test 10: Try to create duplicate email (should fail)
echo -e "\n[TEST 10] Creating duplicate email (should fail)..."
http POST http://localhost:8000/api/users/ \
  name="Duplicate User" \
  email="john@example.com" \
  age=28

# Test 11: List all users
echo -e "\n[TEST 11] Listing all users..."
http GET http://localhost:8000/api/users/

# Test 12: Retrieve a specific user (replace 1 with actual ID)
echo -e "\n[TEST 12] Retrieving user with ID 1..."
http GET http://localhost:8000/api/users/1/

# Test 13: Update a user (PUT - full update)
echo -e "\n[TEST 13] Updating user with ID 1 (PUT)..."
http PUT http://localhost:8000/api/users/1/ \
  name="John Updated" \
  email="john.updated@example.com" \
  age=35

# Test 14: Partial update (PATCH)
echo -e "\n[TEST 14] Partial update user ID 1 (PATCH)..."
http PATCH http://localhost:8000/api/users/1/ \
  age=40

# Test 15: Delete a user
echo -e "\n[TEST 15] Deleting user with ID 1..."
http DELETE http://localhost:8000/api/users/1/

echo -e "\n================================"
echo "Testing Profile API Endpoints"
echo "================================"

# Test 16: Create a user first for profile testing
echo -e "\n[TEST 16] Creating user for profile testing..."
http POST http://localhost:8000/api/users/ \
  name="Profile User" \
  email="profile@example.com" \
  age=28

# Test 17: Create a profile (replace user_id with actual ID)
echo -e "\n[TEST 17] Creating profile for user..."
http POST http://localhost:8000/api/profiles/ \
  user=2 \
  bio="Software developer passionate about Python and Django" \
  profile_picture_url="https://example.com/avatar.jpg" \
  social_links:='{"twitter": "@profileuser", "github": "profileuser"}'

# Test 18: List all profiles
echo -e "\n[TEST 18] Listing all profiles..."
http GET http://localhost:8000/api/profiles/

# Test 19: Retrieve specific profile
echo -e "\n[TEST 19] Retrieving profile with ID 1..."
http GET http://localhost:8000/api/profiles/1/

# Test 20: Update profile
echo -e "\n[TEST 20] Updating profile..."
http PATCH http://localhost:8000/api/profiles/1/ \
  bio="Updated bio: Full-stack developer"

echo -e "\n================================"
echo "Advanced Validation Tests"
echo "================================"

# Test 21: Test email with various invalid formats
echo -e "\n[TEST 21] Testing various invalid email formats..."

echo "  - Missing @ symbol..."
http POST http://localhost:8000/api/users/ \
  name="Test" email="invalidemail.com" age=25

echo "  - Missing domain..."
http POST http://localhost:8000/api/users/ \
  name="Test" email="test@" age=25

echo "  - Spaces in email..."
http POST http://localhost:8000/api/users/ \
  name="Test" email="test @example.com" age=25

# Test 22: Test name edge cases
echo -e "\n[TEST 22] Testing name edge cases..."

echo "  - Single character name (should fail)..."
http POST http://localhost:8000/api/users/ \
  name="A" email="single@example.com" age=25

echo "  - Name with numbers (should succeed)..."
http POST http://localhost:8000/api/users/ \
  name="User123" email="user123@example.com" age=25

# Test 23: Test age edge cases
echo -e "\n[TEST 23] Testing age edge cases..."

echo "  - Negative age..."
http POST http://localhost:8000/api/users/ \
  name="Negative Age" email="negative@example.com" age=-5

echo "  - Float age (should be converted to int or fail)..."
http POST http://localhost:8000/api/users/ \
  name="Float Age" email="float@example.com" age=25.5

echo -e "\n================================"
echo "Test Suite Complete!"
echo "================================"


# ALTERNATIVE: Single command tests for quick validation

# Quick test for valid user creation:
# http POST :8000/api/users/ name="Test User" email="test@example.com" age=30

# Quick test for invalid name:
# http POST :8000/api/users/ name="" email="test@example.com" age=30

# Quick test for invalid email:
# http POST :8000/api/users/ name="Test" email="notanemail" age=30

# Quick test for invalid age:
# http POST :8000/api/users/ name="Test" email="test@example.com" age=150