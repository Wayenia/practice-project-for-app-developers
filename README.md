Voici la traduction en français du document, sans modifier les noms de test burkinabè ou la structure :

-----

# API REST Django avec Développement Assisté par IA

Un projet d'API complet basé sur le **Django REST Framework** développé en collaboration avec plusieurs assistants IA (ChatGPT, Gemini, et Claude), démontrant des pratiques modernes de développement d'API avec une validation et des tests robustes.

## Table des Matières

  * [Aperçu du Projet](https://www.google.com/search?q=%23project-overview)
  * [Configuration de l'Environnement](https://www.google.com/search?q=%23environment-setup)
  * [Conception de la Base de Données](https://www.google.com/search?q=%23database-design)
  * [Structure du Projet](https://www.google.com/search?q=%23project-structure)
  * [Points de Terminaison de l'API](https://www.google.com/search?q=%23api-endpoints)
  * [Validation des Données](https://www.google.com/search?q=%23data-validation)
  * [Tests](https://www.google.com/search?q=%23testing)
  * [Installation et Configuration](https://www.google.com/search?q=%23installation--setup)
  * [Exemples d'Utilisation](https://www.google.com/search?q=%23usage-examples)

-----

## Aperçu du Projet

Ce projet démontre une approche collaborative multi-IA pour la construction d'une API REST prête pour la production avec Django. Chaque assistant IA a contribué à différents aspects du développement :

  * **ChatGPT** : Conception du schéma de la base de données
  * **Gemini** : Boilerplate du projet et logique CRUD
  * **Claude AI** : Validation des données et tests

### Pile Technologique

  * **Framework** : Django 4.x avec Django REST Framework
  * **Base de Données** : PostgreSQL avec support JSONB
  * **Outils** : HTTPie pour les tests d'API
  * **IDE** : VS Code
  * **Contrôle de Version** : Git

-----

## Configuration de l'Environnement

### Prérequis

```bash
# Python 3.8+
python --version

# Pipenv pour la gestion des dépendances
pip install pipenv

# HTTPie pour les tests d'API
pip install httpie
```

### Installation

```bash
# Cloner le dépôt
git clone <repository-url>
cd project

# Installer les dépendances
pipenv install

# Activer l'environnement virtuel
pipenv shell

# Appliquer les migrations
python manage.py makemigrations
python manage.py migrate

# Créer un superutilisateur (optionnel)
python manage.py createsuperuser

# Lancer le serveur de développement
python manage.py runserver
```

-----

## Conception de la Base de Données

### Aperçu du Schéma

La base de données se compose de deux tables principales avec une relation un-à-un :

#### Table `Users` (Utilisateurs)

| Colonne | Type | Contraintes | Description |
| :--- | :--- | :--- | :--- |
| `id` | SERIAL | PRIMARY KEY | Identifiant auto-incrémenté |
| `name` | VARCHAR | NOT NULL, max 100 chars | Nom complet de l'utilisateur |
| `email` | VARCHAR | UNIQUE, NOT NULL | Adresse e-mail de l'utilisateur |
| `age` | INTEGER | OPTIONAL | Âge de l'utilisateur (1-120) |
| `createdAt` | TIMESTAMP | DEFAULT CURRENT\_TIMESTAMP | Horodatage de création de l'enregistrement |
| `updatedAt` | TIMESTAMP | AUTO UPDATE | Horodatage de mise à jour de l'enregistrement |

#### Table `Profiles` (Profils)

| Colonne | Type | Contraintes | Description |
| :--- | :--- | :--- | :--- |
| `id` | SERIAL | PRIMARY KEY | Identifiant auto-incrémenté |
| `user_id` | INTEGER | FOREIGN KEY, NOT NULL | Référence à `users.id` |
| `bio` | TEXT | OPTIONAL | Biographie de l'utilisateur |
| `profile_picture_url` | VARCHAR | OPTIONAL | URL de l'image de profil |
| `social_links` | JSONB | OPTIONAL | Objet JSON des liens de médias sociaux |

### Commandes de Configuration SQL

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

### Diagramme de Relations

```
┌─────────────┐         1:1          ┌─────────────┐
│ Utilisateurs│◄─────────────────────┤   Profils   │
├─────────────┤                      ├─────────────┤
│ id (PK)     │                      │ id (PK)     │
│ name        │                      │ user_id (FK)│
│ email       │                      │ bio         │
│ age         │                      │ picture_url │
│ createdAt   │                      │ social_links│
│ updatedAt   │                      └─────────────┘
└─────────────┘
```

-----

## Structure du Projet

```
project/
├── apis/
│   ├── __init__.py
│   ├── admin.py
│   ├── apps.py
│   ├── models.py           # Modèles de base de données (User, Profile)
│   ├── serializers.py      # Sérialiseurs DRF avec validation
│   ├── views.py            # ViewSets pour les opérations CRUD
│   ├── urls.py             # Configuration du routage de l'API
│   ├── tests.py            # Suite de tests automatisés
│   └── migrations/
│       └── __init__.py
├── config/
│   ├── __init__.py
│   ├── settings.py         # Configuration Django
│   ├── urls.py             # Configuration principale des URL
│   ├── wsgi.py
│   └── asgi.py
├── manage.py
├── Pipfile                 # Dépendances
├── Pipfile.lock
└── README.md
```

-----

## Points de Terminaison de l'API

### URL de Base

```
http://localhost:8000/api/
```

### Points de Terminaison `User` (Utilisateur)

| Méthode | Point de Terminaison | Description | Authentification |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/users/` | Liste tous les utilisateurs | Non |
| `POST` | `/api/users/` | Crée un nouvel utilisateur | Non |
| `GET` | `/api/users/{id}/` | Récupère un utilisateur spécifique | Non |
| `PUT` | `/api/users/{id}/` | Mise à jour complète de l'utilisateur | Non |
| `PATCH` | `/api/users/{id}/` | Mise à jour partielle de l'utilisateur | Non |
| `DELETE` | `/api/users/{id}/` | Supprime un utilisateur | Non |

### Points de Terminaison `Profile` (Profil)

| Méthode | Point de Terminaison | Description | Authentification |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/profiles/` | Liste tous les profils | Non |
| `POST` | `/api/profiles/` | Crée un nouveau profil | Non |
| `GET` | `/api/profiles/{id}/` | Récupère un profil spécifique | Non |
| `PUT` | `/api/profiles/{id}/` | Mise à jour complète du profil | Non |
| `PATCH` | `/api/profiles/{id}/` | Mise à jour partielle du profil | Non |
| `DELETE` | `/api/profiles/{id}/` | Supprime un profil | Non |

### Exemples de Requête/Réponse

#### Créer un Utilisateur (`POST /api/users/`)

**Requête :**

```json
{
  "name": "Issa Compaore",
  "email": "issa.compaore@bfaso.org",
  "age": 35
}
```

**Réponse (201 Created) :**

```json
{
  "id": 1,
  "name": "Issa Compaore",
  "email": "issa.compaore@bfaso.org",
  "age": 35,
  "profile": null,
  "createdAt": "2025-12-11T10:30:00Z",
  "updatedAt": "2025-12-11T10:30:00Z"
}
```

#### Créer un Profil (`POST /api/profiles/`)

**Requête :**

```json
{
  "user": 1,
  "bio": "Développeur full-stack Burkinabè, passionné par les solutions mobiles pour l'agriculture locale.",
  "profile_picture_url": "https://example.com/issa.jpg",
  "social_links": {
    "twitter": "@issabf",
    "github": "issa-compaore"
  }
}
```

**Réponse (201 Created) :**

```json
{
  "id": 1,
  "user": 1,
  "bio": "Développeur full-stack Burkinabè, passionné par les solutions mobiles pour l'agriculture locale.",
  "profile_picture_url": "https://example.com/issa.jpg",
  "social_links": {
    "twitter": "@issabf",
    "github": "issa-compaore"
  }
}
```

-----

## Validation des Données

### Règles de Validation

#### Validation du Champ `Name` (Nom)

**Exigences :**

  * ✅ Doit être une chaîne non vide
  * ✅ Ne peut pas contenir uniquement des espaces
  * ✅ Minimum 2 caractères après nettoyage des espaces
  * ✅ Nettoie automatiquement les espaces

**Implémentation :**

```python
def validate_name(self, value):
    if not value or not value.strip():
        raise ValidationError("Name cannot be empty")
    if len(value.strip()) < 2:
        raise ValidationError("Name must be at least 2 characters")
    return value.strip()
```

**Cas de Test :**

  * ❌ Chaîne vide : `""`
  * ❌ Seulement des espaces : `"   "`
  * ❌ Caractère unique : `"A"`
  * ✅ Nom valide : `"Alizeta Zongo"`

#### Validation du Champ `Email`

**Exigences :**

  * ✅ Doit correspondre à un format d'e-mail valide (regex)
  * ✅ Doit contenir le symbole `@`
  * ✅ Doit avoir une structure de domaine valide
  * ✅ Vérification d'unicité insensible à la casse
  * ✅ Automatiquement converti en minuscules

**Implémentation :**

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

**Cas de Test :**

  * ❌ Pas de symbole `@` : `"invalidemail.com"`
  * ❌ Domaine manquant : `"user@"`
  * ❌ Espaces : `"user @example.com"`
  * ❌ Doublon : `"existing@example.com"`
  * ✅ E-mail valide : `"ouedraogo.marie@bfaso.org"`

#### Validation du Champ `Age` (Âge)

**Exigences :**

  * ✅ Doit être une valeur numérique (entier)
  * ✅ Doit être compris entre 1 et 120 (inclus)
  * ✅ Le champ est optionnel (peut être null)

**Implémentation :**

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

**Cas de Test :**

  * ❌ Zéro : `0`
  * ❌ Négatif : `-5`
  * ❌ Au-dessus de la limite : `121`
  * ✅ Valeurs limites : `1`, `120`
  * ✅ Âge valide : `42`
  * ✅ Aucun âge fourni : `null`

### Format de Réponse d'Erreur

Lorsqu'une validation échoue, l'API renvoie un statut **400 Bad Request** avec des messages d'erreur détaillés :

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

-----

## Tests

### Suite de Tests Automatisés

Le projet comprend des tests automatisés complets utilisant le framework de test de Django.

**Exécuter tous les tests :**

```bash
python manage.py test
```

**Couverture des tests :**

```bash
# Installer coverage
pip install coverage

# Exécuter les tests avec coverage
coverage run --source='.' manage.py test
coverage report
coverage html  # Générer le rapport HTML
```

### Catégories de Tests

#### 1\. Tests de Données Valides

  * ✅ Création d'utilisateur avec tous les champs valides
  * ✅ Création d'utilisateur sans le champ optionnel `age`
  * ✅ Mise à jour d'utilisateur avec des données valides
  * ✅ Mise à jour partielle (`PATCH`)

#### 2\. Tests de Validation du Nom

  * ✅ Rejet du nom vide
  * ✅ Rejet du nom uniquement composé d'espaces
  * ✅ Rejet du nom trop court (\< 2 caractères)
  * ✅ Nettoyage des espaces

#### 3\. Tests de Validation de l'Email

  * ✅ Rejet du format invalide
  * ✅ Rejet de l'e-mail en double
  * ✅ Unicité insensible à la casse
  * ✅ Divers formats invalides

#### 4\. Tests de Validation de l'Âge

  * ✅ Inférieur au minimum (\< 1)
  * ✅ Supérieur au maximum (\> 120)
  * ✅ Valeurs limites (1, 120)
  * ✅ Gestion du champ optionnel
  * ✅ Rejet de valeur non entière

#### 5\. Tests des Opérations CRUD

  * ✅ Lister tous les utilisateurs
  * ✅ Récupérer un utilisateur spécifique
  * ✅ Mettre à jour l'utilisateur (`PUT`)
  * ✅ Mise à jour partielle de l'utilisateur (`PATCH`)
  * ✅ Supprimer l'utilisateur

### Test Manuel avec HTTPie

**Installer HTTPie :**

```bash
pip install httpie
```

**Commandes de test de base :**

1.  **Créer un utilisateur valide :**

<!-- end list -->

```bash
http POST :8000/api/users/ \
  name="Fatoumata Traore" \
  email="fatou.traore@bfaso.org" \
  age=29
```

2.  **Tester un nom vide (devrait échouer) :**

<!-- end list -->

```bash
http POST :8000/api/users/ \
  name="" \
  email="test@example.com" \
  age=25
```

3.  **Tester un e-mail invalide (devrait échouer) :**

<!-- end list -->

```bash
http POST :8000/api/users/ \
  name="Karim Sawadogo" \
  email="notanemail" \
  age=25
```

4.  **Tester un âge invalide (devrait échouer) :**

<!-- end list -->

```bash
http POST :8000/api/users/ \
  name="Nafissatou Diallo" \
  email="nafissatou@example.com" \
  age=150
```

5.  **Lister tous les utilisateurs :**

<!-- end list -->

```bash
http GET :8000/api/users/
```

6.  **Mettre à jour l'utilisateur :**

<!-- end list -->

```bash
http PATCH :8000/api/users/1/ age=30
```

7.  **Supprimer l'utilisateur :**

<!-- end list -->

```bash
http DELETE :8000/api/users/1/
```

### Résumé des Résultats des Tests

Après avoir exécuté la suite de tests complète, vous devriez voir des résultats similaires à ceux-ci :

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

-----

## Exemples d'Utilisation

### Workflow Utilisateur Complet

```bash
# 1. Créer un utilisateur
http POST :8000/api/users/ \
  name="Adama Kaboré" \
  email="adama.kabore@bf.net" \
  age=40

# Response: { "id": 1, "name": "Adama Kaboré", ... }

# 2. Créer un profil pour l'utilisateur
http POST :8000/api/profiles/ \
  user=1 \
  bio="Spécialiste en gestion de projets numériques, basé à Ouagadougou." \
  profile_picture_url="https://example.com/adama.jpg" \
  social_links:='{"linkedin": "adama-kabore", "twitter": "@adamabf"}'

# 3. Récupérer l'utilisateur avec son profil
http GET :8000/api/users/1/

# 4. Mettre à jour l'âge de l'utilisateur
http PATCH :8000/api/users/1/ age=41

# 5. Mettre à jour la biographie du profil
http PATCH :8000/api/profiles/1/ \
  bio="Consultant senior en transformation digitale."

# 6. Lister tous les utilisateurs
http GET :8000/api/users/

# 7. Supprimer l'utilisateur (supprime également le profil par cascade)
http DELETE :8000/api/users/1/
```

### Exemples de Gestion des Erreurs

**Erreurs de validation multiples :**

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

-----

## Processus de Développement

### Flux de Travail Assisté par IA

1.  **ChatGPT** - Conception de la Base de Données

      * Création du schéma normalisé
      * Définition des relations
      * Génération des commandes SQL

2.  **Gemini** - Boilerplate et Modèles

      * Configuration de la structure du projet Django
      * Création des modèles avec des relations appropriées
      * Implémentation des sérialiseurs et des vues

3.  **Claude AI** - Validation et Tests

      * Ajout d'une logique de validation complète
      * Création de la suite de tests automatisés
      * Développement des scripts de test HTTPie
      * Amélioration de la documentation

### Avantages de l'Approche Multi-IA

  * ✅ Perspectives diverses sur les décisions de conception
  * ✅ Couverture de validation complète
  * ✅ Codebase bien documentée
  * ✅ Suite de tests prête pour la production
  * ✅ Meilleures pratiques provenant de sources multiples

-----

## Améliorations Futures

  * [ ] Ajouter l'authentification et l'autorisation
  * [ ] Implémenter la pagination pour les points de terminaison de liste
  * [ ] Ajouter des fonctionnalités de filtrage et de recherche
  * [ ] Créer une documentation d'API avec Swagger/OpenAPI
  * [ ] Ajouter une limitation de débit (rate limiting)
  * [ ] Implémenter la mise en cache avec Redis
  * [ ] Ajouter le téléchargement de fichiers pour les images de profil
  * [ ] Créer un tableau de bord d'administration

-----

## Contact pour questions ou commentaires

geniestat.andal@gmail.com

-----

**By SOULAI WAYENIA**
