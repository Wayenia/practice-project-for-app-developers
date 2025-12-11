# Django REST API with AI-Assisted Development

A comprehensive Django REST Framework API project developed collaboratively with multiple AI assistants (ChatGPT, Gemini, and Claude), demonstrating modern API development practices with robust validation and testing.

## Table of Contents

- [Project Overview](#project-overview)
- [Environment Setup](#environment-setup)
- [Database Design](#database-design)
- [Project Structure](#project-structure)
- [API Endpoints](#api-endpoints)
- [Data Validation](#data-validation)
- [Testing](#testing)
- [Installation & Setup](#installation--setup)
- [Usage Examples](#usage-examples)

---

## Project Overview

This project demonstrates a multi-AI collaborative approach to building a production-ready REST API with Django. Each AI assistant contributed to different aspects of the development:

- **ChatGPT**: Database schema design
- **Gemini**: Project boilerplate and CRUD logic
- **Claude AI**: Data validation and testing

### Tech Stack

- **Framework**: Django 4.x with Django REST Framework
- **Database**: PostgreSQL with JSONB support
- **Tools**: HTTPie for API testing
- **IDE**: VS Code
- **Version Control**: Git

---

## Environment Setup

### Prerequisites

```bash
# Python 3.8+
python --version

# Pipenv for dependency management
pip install pipenv

# HTTPie for API testing
pip install httpie
```

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd project

# Install dependencies
pipenv install

# Activate virtual environment
pipenv shell

# Apply migrations
python manage.py makemigrations
python manage.py migrate

# Create superuser (optional)
python manage.py createsuperuser

# Run development server
python manage.py runserver
```

---

## Database Design

### Schema Overview

The database consists of two main tables with a one-to-one relationship:

#### Users Table

| Column     | Type      | Constraints              | Description                    |
|------------|-----------|--------------------------|--------------------------------|
| id         | SERIAL    | PRIMARY KEY              | Auto-incrementing identifier   |
| name       | VARCHAR   | NOT NULL, max 100 chars  | User's full name               |
| email      | VARCHAR   | UNIQUE, NOT NULL         | User's email address           |
| age        | INTEGER   | OPTIONAL                 | User's age (1-120)             |
| createdAt  | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP| Record creation timestamp      |
| updatedAt  | TIMESTAMP | AUTO UPDATE              | Record update timestamp        |

#### Profiles Table

| Column               | Type      | Constraints        | Description                       |
|----------------------|-----------|--------------------|-----------------------------------|
| id                   | SERIAL    | PRIMARY KEY        | Auto-incrementing identifier      |
| user_id              | INTEGER   | FOREIGN KEY, NOT NULL | Reference to users.id          |
| bio                  | TEXT      | OPTIONAL           | User biography                    |
| profile_picture_url  | VARCHAR   | OPTIONAL           | URL to profile picture            |
| social_links         | JSONB     | OPTIONAL           | JSON object of social media links |

### SQL Setup Commands

```sql
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
```

### Relationship Diagram

```
┌─────────────┐         1:1          ┌─────────────┐
│    Users    │◄─────────────────────┤  Profiles   │
├─────────────┤                      ├─────────────┤
│ id (PK)     │                      │ id (PK)     │
│ name        │                      │ user_id (FK)│
│ email       │                      │ bio         │
│ age         │                      │ picture_url │
│ createdAt   │                      │ social_links│
│ updatedAt   │                      └─────────────┘
└─────────────┘
```

---

## Project Structure

```
project/
├── apis/
│   ├── __init__.py
│   ├── admin.py
│   ├── apps.py
│   ├── models.py           # Database models (User, Profile)
│   ├── serializers.py      # DRF serializers with validation
│   ├── views.py            # ViewSets for CRUD operations
│   ├── urls.py             # API routing configuration
│   ├── tests.py            # Automated test suite
│   └── migrations/
│       └── __init__.py
├── config/
│   ├── __init__.py
│   ├── settings.py         # Django configuration
│   ├── urls.py             # Main URL configuration
│   ├── wsgi.py
│   └── asgi.py
├── manage.py
├── Pipfile                 # Dependencies
├── Pipfile.lock
└── README.md
```

---

## API Endpoints

### Base URL

```
http://localhost:8000/api/
```

### User Endpoints

| Method | Endpoint          | Description                | Authentication |
|--------|-------------------|----------------------------|----------------|
| GET    | /api/users/       | List all users             | No             |
| POST   | /api/users/       | Create new user            | No             |
| GET    | /api/users/{id}/  | Retrieve specific user     | No             |
| PUT    | /api/users/{id}/  | Full update user           | No             |
| PATCH  | /api/users/{id}/  | Partial update user        | No             |
| DELETE | /api/users/{id}/  | Delete user                | No             |

### Profile Endpoints

| Method | Endpoint             | Description                | Authentication |
|--------|----------------------|----------------------------|----------------|
| GET    | /api/profiles/       | List all profiles          | No             |
| POST   | /api/profiles/       | Create new profile         | No             |
| GET    | /api/profiles/{id}/  | Retrieve specific profile  | No             |
| PUT    | /api/profiles/{id}/  | Full update profile        | No             |
| PATCH  | /api/profiles/{id}/  | Partial update profile     | No             |
| DELETE | /api/profiles/{id}/  | Delete profile             | No             |

### Request/Response Examples

#### Create User (POST /api/users/)

**Request:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "age": 30
}
```

**Response (201 Created):**
```json
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "age": 30,
  "profile": null,
  "createdAt": "2025-12-11T10:30:00Z",
  "updatedAt": "2025-12-11T10:30:00Z"
}
```

#### Create Profile (POST /api/profiles/)

**Request:**
```json
{
  "user": 1,
  "bio": "Software developer passionate about Python",
  "profile_picture_url": "https://example.com/avatar.jpg",
  "social_links": {
    "twitter": "@johndoe",
    "github": "johndoe"
  }
}
```

**Response (201 Created):**
```json
{
  "id": 1,
  "user": 1,
  "bio": "Software developer passionate about Python",
  "profile_picture_url": "https://example.com/avatar.jpg",
  "social_links": {
    "twitter": "@johndoe",
    "github": "johndoe"
  }
}
```

---

## Data Validation

### Validation Rules

#### Name Field Validation

**Requirements:**
- ✅ Must be a non-empty string
- ✅ Cannot contain only whitespace
- ✅ Minimum 2 characters after trimming
- ✅ Automatically trims whitespace

**Implementation:**
```python
def validate_name(self, value):
    if not value or not value.strip():
        raise ValidationError("Name cannot be empty")
    if len(value.strip()) < 2:
        raise ValidationError("Name must be at least 2 characters")
    return value.strip()
```

**Test Cases:**
- ❌ Empty string: `""`
- ❌ Whitespace only: `"   "`
- ❌ Single character: `"A"`
- ✅ Valid name: `"John Doe"`

#### Email Field Validation

**Requirements:**
- ✅ Must match valid email format (regex)
- ✅ Must contain @ symbol
- ✅ Must have valid domain structure
- ✅ Case-insensitive uniqueness check
- ✅ Automatically converted to lowercase

**Implementation:**
```python
def validate_email(self, value):
    email_pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    if not re.match(email_pattern, value):
        raise ValidationError("Enter a valid email address")
    # Check uniqueness
    if User.objects.filter(email__iexact=value).exclude(id=instance_id).exists():
        raise ValidationError("Email already exists")
    return value.lower()
```

**Test Cases:**
- ❌ No @ symbol: `"invalidemail.com"`
- ❌ Missing domain: `"user@"`
- ❌ Spaces: `"user @example.com"`
- ❌ Duplicate: `"existing@example.com"`
- ✅ Valid email: `"user@example.com"`

#### Age Field Validation

**Requirements:**
- ✅ Must be a numerical value (integer)
- ✅ Must be between 1 and 120 (inclusive)
- ✅ Field is optional (can be null)

**Implementation:**
```python
def validate_age(self, value):
    if value is None:
        return value  # Optional field
    if not isinstance(value, int):
        raise ValidationError("Age must be numerical")
    if value < 1 or value > 120:
        raise ValidationError("Age must be between 1 and 120")
    return value
```

**Test Cases:**
- ❌ Zero: `0`
- ❌ Negative: `-5`
- ❌ Above limit: `121`
- ✅ Boundary values: `1`, `120`
- ✅ Valid age: `30`
- ✅ No age provided: `null`

### Error Response Format

When validation fails, the API returns a 400 Bad Request with detailed error messages:

```json
{
  "name": [
    "Name cannot be empty or contain only whitespace."
  ],
  "email": [
    "Enter a valid email address."
  ],
  "age": [
    "Age must be between 1 and 120."
  ]
}
```

---

## Testing

### Automated Test Suite

The project includes comprehensive automated tests using Django's test framework.

**Run all tests:**
```bash
python manage.py test
```

**Test coverage:**
```bash
# Install coverage
pip install coverage

# Run tests with coverage
coverage run --source='.' manage.py test
coverage report
coverage html  # Generate HTML report
```

### Test Categories

#### 1. Valid Data Tests
- ✅ Create user with all valid fields
- ✅ Create user without optional age field
- ✅ Update user with valid data
- ✅ Partial update (PATCH)

#### 2. Name Validation Tests
- ✅ Empty name rejection
- ✅ Whitespace-only name rejection
- ✅ Short name rejection (< 2 chars)
- ✅ Whitespace trimming

#### 3. Email Validation Tests
- ✅ Invalid format rejection
- ✅ Duplicate email rejection
- ✅ Case-insensitive uniqueness
- ✅ Various invalid formats

#### 4. Age Validation Tests
- ✅ Below minimum (< 1)
- ✅ Above maximum (> 120)
- ✅ Boundary values (1, 120)
- ✅ Optional field handling
- ✅ Non-integer rejection

#### 5. CRUD Operations Tests
- ✅ List all users
- ✅ Retrieve specific user
- ✅ Update user (PUT)
- ✅ Partial update (PATCH)
- ✅ Delete user

### Manual Testing with HTTPie

**Install HTTPie:**
```bash
pip install httpie
```

**Basic test commands:**

1. **Create valid user:**
```bash
http POST :8000/api/users/ \
  name="John Doe" \
  email="john@example.com" \
  age=30
```

2. **Test empty name (should fail):**
```bash
http POST :8000/api/users/ \
  name="" \
  email="test@example.com" \
  age=25
```

3. **Test invalid email (should fail):**
```bash
http POST :8000/api/users/ \
  name="Test User" \
  email="notanemail" \
  age=25
```

4. **Test invalid age (should fail):**
```bash
http POST :8000/api/users/ \
  name="Test User" \
  email="test@example.com" \
  age=150
```

5. **List all users:**
```bash
http GET :8000/api/users/
```

6. **Update user:**
```bash
http PATCH :8000/api/users/1/ age=35
```

7. **Delete user:**
```bash
http DELETE :8000/api/users/1/
```

### Test Results Summary

After running the complete test suite, you should see results similar to:

```
----------------------------------------------------------------------
Ran 20 tests in 2.453s

OK

Test Results:
✅ Valid data creation: PASSED
✅ Empty name validation: PASSED
✅ Whitespace name validation: PASSED
✅ Invalid email format: PASSED
✅ Duplicate email: PASSED
✅ Age below minimum: PASSED
✅ Age above maximum: PASSED
✅ Age boundary values: PASSED
✅ Optional age field: PASSED
✅ User update: PASSED
✅ User partial update: PASSED
✅ User deletion: PASSED
✅ List users: PASSED
✅ Retrieve user: PASSED
```

---

## Usage Examples

### Complete User Workflow

```bash
# 1. Create a user
http POST :8000/api/users/ \
  name="Alice Smith" \
  email="alice@example.com" \
  age=28

# Response: { "id": 1, "name": "Alice Smith", ... }

# 2. Create profile for the user
http POST :8000/api/profiles/ \
  user=1 \
  bio="Full-stack developer" \
  profile_picture_url="https://example.com/alice.jpg" \
  social_links:='{"github": "alicesmith"}'

# 3. Retrieve user with profile
http GET :8000/api/users/1/

# 4. Update user age
http PATCH :8000/api/users/1/ age=29

# 5. Update profile bio
http PATCH :8000/api/profiles/1/ \
  bio="Senior full-stack developer"

# 6. List all users
http GET :8000/api/users/

# 7. Delete user (cascade deletes profile)
http DELETE :8000/api/users/1/
```

### Error Handling Examples

**Multiple validation errors:**
```bash
http POST :8000/api/users/ \
  name="" \
  email="invalid" \
  age=200

# Response (400 Bad Request):
{
  "name": ["Name cannot be empty"],
  "email": ["Enter a valid email address"],
  "age": ["Age must be between 1 and 120"]
}
```

---

## Development Process

### AI-Assisted Development Workflow

1. **ChatGPT** - Database Design
   - Created normalized schema
   - Defined relationships
   - Generated SQL commands

2. **Gemini** - Boilerplate & Models
   - Set up Django project structure
   - Created models with proper relationships
   - Implemented serializers and views

3. **Claude AI** - Validation & Testing
   - Added comprehensive validation logic
   - Created automated test suite
   - Developed HTTPie test scripts
   - Enhanced documentation

### Benefits of Multi-AI Approach

- ✅ Diverse perspectives on design decisions
- ✅ Comprehensive validation coverage
- ✅ Well-documented codebase
- ✅ Production-ready testing suite
- ✅ Best practices from multiple sources

---

## Future Enhancements

- [ ] Add authentication and authorization
- [ ] Implement pagination for list endpoints
- [ ] Add filtering and search capabilities
- [ ] Create API documentation with Swagger/OpenAPI
- [ ] Add rate limiting
- [ ] Implement caching with Redis
- [ ] Add file upload for profile pictures
- [ ] Create admin dashboard

---

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

---

## License

This project is licensed under the MIT License.

---

## Contact

For questions or feedback, please open an issue in the repository.


---

**Built with using Django, Claude AI, ChatGPT, and Gemini**