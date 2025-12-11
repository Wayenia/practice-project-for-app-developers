# API REST Django

Un projet d'API complet basé sur le **Django REST Framework** qui démontre des pratiques modernes de développement d'API avec une validation et des tests robustes.

## Table des Matières

  \* [Aperçu du Projet]
  \* [Configuration de l'Environnement]
  \* [Conception de la Base de Données]
  \* [Structure du Projet]
  \* [Points de Terminaison de l'API]
  \* [Validation des Données]
  \* [Tests]
  \* [Exemples d'Utilisation]
  \* [Processus de Développement]
  \* [Améliorations Futures]
  \* [Licence]

-----

## Aperçu du Projet

Ce projet démontre une approche pour la construction d'une API REST prête pour la production avec Django.

### Pile Technologique

  \* **Framework :** Django 6.0 avec Django REST Framework
  \* **Base de Données :** PostgreSQL avec support JSONB
  \* **Outils :** HTTPie pour les tests d'API
  \* **IDE :** VS Code
  \* **Contrôle de Version :** Git

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

La base de données se compose de deux tables principales avec une relation un-à-un.

#### Table `Users` (Utilisateurs)

| Colonne | Type | Contraintes | Description |
| :--- | :--- | :--- | :--- |
| `id` | SERIAL | PRIMARY KEY | Identifiant auto-incrémenté |
| `name` | VARCHAR | NOT NULL, max 100 chars | Nom complet de l'utilisateur |
| `email` | VARCHAR | UNIQUE, NOT NULL | Adresse e-mail de l'utilisateur |
| `age` | INTEGER | OPTIONNEL | Âge de l'utilisateur (1-120) |
| `createdAt` | TIMESTAMP | DEFAULT CURRENT\_TIMESTAMP | Horodatage de création de l'enregistrement |
| `updatedAt` | TIMESTAMP | AUTO UPDATE | Horodatage de mise à jour de l'enregistrement |

#### Table `Profiles` (Profils)

| Colonne | Type | Contraintes | Description |
| :--- | :--- | :--- | :--- |
| `id` | SERIAL | PRIMARY KEY | Identifiant auto-incrémenté |
| `user_id` | INTEGER | FOREIGN KEY, NOT NULL | Référence à `users.id` |
| `bio` | TEXT | OPTIONNEL | Biographie de l'utilisateur |
| `profile_picture_url` | VARCHAR | OPTIONNEL | URL de l'image de profil |
| `social_links` | JSONB | OPTIONNEL | Objet JSON des liens de médias sociaux |

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
┌─────────────┐         1:1          ┌─────────────┐
│ Utilisateurs│◄─────────────────────┤   Profils   │
├─────────────┤                      ├─────────────┤
│ id (PK)     │                      │ id (PK)     │
│ name        │                      │ user_id (FK)│
│ email       │                      │ bio         │
│ age         │                      │ picture_url │
│ createdAt   │                      │ social_links│
│ updatedAt   │                      └─────────────┘
└─────────────┘
```

-----

## Structure du Projet

```
project/
├── apis/
│   ├── __init__.py
│   ├── admin.py
│   ├── apps.py
│   ├── models.py           # Modèles de base de données (User, Profile)
│   ├── serializers.py      # Sérialiseurs DRF avec validation
│   ├── views.py            # ViewSets pour les opérations CRUD
│   ├── urls.py             # Configuration du routage de l'API
│   ├── tests.py            # Suite de tests automatisés
│   └── migrations/
│       └── __init__.py
├── config/
│   ├── __init__.py
│   ├── settings.py         # Configuration Django
│   ├── urls.py             # Configuration principale des URL
│   ├── wsgi.py
│   └── asgi.py
├── manage.py
├── Pipfile                 # Dépendances
├── Pipfile.lock
└── README.md
```

-----

## Points de Terminaison de l'API

### URL de Base

`http://localhost:8000/api/`

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
  "name": "Oumar Kaboré",
  "email": "oumar.kabore@example.bf",
  "age": 30
}
```

**Réponse (201 Created) :**

```json
{
  "id": 1,
  "name": "Oumar Kaboré",
  "email": "oumar.kabore@example.bf",
  "age": 30,
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
  "bio": "Développeur de solutions mobiles pour le marché local au Faso",
  "profile_picture_url": "https://example.com/avatar.jpg",
  "social_links": {
    "twitter": "@Oumar_BF",
    "github": "OumarKabore"
  }
}
```

**Réponse (201 Created) :**

```json
{
  "id": 1,
  "user": 1,
  "bio": "Développeur de solutions mobiles pour le marché local au Faso",
  "profile_picture_url": "https://example.com/avatar.jpg",
  "social_links": {
    "twitter": "@Oumar_BF",
    "github": "OumarKabore"
  }
}
```

-----

## Validation des Données

### Règles de Validation

#### Validation du Champ `Name` (Nom)

**Exigences :**

  \* ✅ Doit être une chaîne non vide
  \* ✅ Ne peut pas contenir uniquement des espaces
  \* ✅ Minimum 2 caractères après nettoyage des espaces
  \* ✅ Nettoie automatiquement les espaces (trim)

**Implémentation :**

```python
def validate_name(self, value):
    if not value or not value.strip():
        raise ValidationError("Le nom ne peut pas être vide")
    if len(value.strip()) < 2:
        raise ValidationError("Le nom doit contenir au moins 2 caractères")
    return value.strip()
```

**Cas de Test :**

  \* ❌ Chaîne vide : `""`
  \* ❌ Seulement des espaces : `"   "`
  \* ❌ Caractère unique : `"A"`
  \* ✅ Nom valide : **`"Oumar Kaboré"`**

#### Validation du Champ `Email`

**Exigences :**

  \* ✅ Doit correspondre à un format d'e-mail valide (regex)
  \* ✅ Doit contenir le symbole `@`
  \* ✅ Doit avoir une structure de domaine valide
  \* ✅ Vérification d'unicité insensible à la casse
  \* ✅ Automatiquement converti en minuscules

**Implémentation :**

```python
def validate_email(self, value):
    email_pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    if not re.match(email_pattern, value):
        raise ValidationError("Entrez une adresse e-mail valide")
    # Vérification de l'unicité
    if User.objects.filter(email__iexact=value).exclude(id=instance_id).exists():
        raise ValidationError("Cet e-mail existe déjà")
    return value.lower()
```

**Cas de Test :**

  \* ❌ Pas de symbole `@` : `"invalidemail.com"`
  \* ❌ Domaine manquant : `"user@"`
  \* ❌ Espaces : `"user @example.bf"`
  \* ❌ Doublon : `"existing@example.bf"`
  \* ✅ E-mail valide : `"user@example.bf"`

#### Validation du Champ `Age`

**Exigences :**

  \* ✅ Doit être une valeur numérique (entier)
  \* ✅ Doit être compris entre 1 et 120 (inclus)
  \* ✅ Le champ est optionnel (peut être null)

**Implémentation :**

```python
def validate_age(self, value):
    if value is None:
        return value  # Champ optionnel
    if not isinstance(value, int):
        raise ValidationError("L'âge doit être numérique")
    if value < 1 or value > 120:
        raise ValidationError("L'âge doit être compris entre 1 et 120")
    return value
```

**Cas de Test :**

  \* ❌ Zéro : `0`
  \* ❌ Négatif : `-5`
  \* ❌ Au-dessus de la limite : `121`
  \* ✅ Valeurs limites : `1`, `120`
  \* ✅ Âge valide : `30`
  \* ✅ Aucun âge fourni : `null`

### Format de Réponse d'Erreur

Lorsqu'une validation échoue, l'API renvoie un statut **400 Bad Request** avec des messages d'erreur détaillés :

```json
{
  "name": [
    "Le nom ne peut pas être vide ou contenir uniquement des espaces."
  ],
  "email": [
    "Entrez une adresse e-mail valide."
  ],
  "age": [
    "L'âge doit être compris entre 1 et 120."
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
coverage html  # Générer le rapport HTML
```

### Catégories de Tests

1.  **Tests de Données Valides**

      \* ✅ Création d'utilisateur avec tous les champs valides
      \* ✅ Création d'utilisateur sans le champ optionnel `age`
      \* ✅ Mise à jour d'utilisateur avec des données valides
      \* ✅ Mise à jour partielle (`PATCH`)

2.  **Tests de Validation du Nom**

      \* ✅ Rejet du nom vide
      \* ✅ Rejet du nom uniquement composé d'espaces
      \* ✅ Rejet du nom trop court (\< 2 caractères)
      \* ✅ Nettoyage des espaces (trim)

3.  **Tests de Validation de l'Email**

      \* ✅ Rejet du format invalide
      \* ✅ Rejet de l'e-mail en double
      \* ✅ Unicité insensible à la casse
      \* ✅ Divers formats invalides

4.  **Tests de Validation de l'Âge**

      \* ✅ Inférieur au minimum (\< 1)
      \* ✅ Supérieur au maximum (\> 120)
      \* ✅ Valeurs limites (1, 120)
      \* ✅ Gestion du champ optionnel
      \* ✅ Rejet de valeur non entière

5.  **Tests des Opérations CRUD**

      \* ✅ Lister tous les utilisateurs
      \* ✅ Récupérer un utilisateur spécifique
      \* ✅ Mettre à jour l'utilisateur (`PUT`)
      \* ✅ Mise à jour partielle de l'utilisateur (`PATCH`)
      \* ✅ Supprimer l'utilisateur

### Test Manuel avec HTTPie

**Installer HTTPie :**

```bash
pip install httpie
```

**Commandes de test de base :**

```bash
# Créer un utilisateur valide :
http POST :8000/api/users/ \
  name="Salif Coulibaly" \
  email="salif.coulibaly@example.bf" \
  age=30

# Tester un nom vide (devrait échouer) :
http POST :8000/api/users/ \
  name="" \
  email="test@example.bf" \
  age=25

# Tester un e-mail invalide (devrait échouer) :
http POST :8000/api/users/ \
  name="Test User" \
  email="notanemail" \
  age=25

# Tester un âge invalide (devrait échouer) :
http POST :8000/api/users/ \
  name="Test User" \
  email="test@example.bf" \
  age=150

# Lister tous les utilisateurs :
http GET :8000/api/users/

# Mettre à jour l'utilisateur :
http PATCH :8000/api/users/1/ age=35

# Supprimer l'utilisateur :
http DELETE :8000/api/users/1/
```

### Résumé des Résultats des Tests

Après avoir exécuté la suite de tests complète, vous devriez voir des résultats similaires à ceux-ci :

```
----------------------------------------------------------------------
Ran 20 tests in 2.453s

OK

Résultats des tests :
✅ Création de données valides : RÉUSSI
✅ Validation du nom vide : RÉUSSI
✅ Validation du nom avec espaces : RÉUSSI
✅ Format d'e-mail invalide : RÉUSSI
✅ E-mail en double : RÉUSSI
✅ Âge inférieur au minimum : RÉUSSI
✅ Âge supérieur au maximum : RÉUSSI
✅ Valeurs limites de l'âge : RÉUSSI
✅ Champ d'âge optionnel : RÉUSSI
✅ Mise à jour d'utilisateur : RÉUSSI
✅ Mise à jour partielle d'utilisateur : RÉUSSI
✅ Suppression d'utilisateur : RÉUSSI
✅ Lister les utilisateurs : RÉUSSI
✅ Récupérer l'utilisateur : RÉUSSI
```

-----

## Exemples d'Utilisation

### Workflow Utilisateur Complet

```bash
# 1. Créer un utilisateur
http POST :8000/api/users/ \
  name="Fatou Ouédraogo" \
  email="fatou.ouedraogo@example.bf" \
  age=28

# Réponse : { "id": 1, "name": "Fatou Ouédraogo", ... }

# 2. Créer un profil pour l'utilisateur
http POST :8000/api/profiles/ \
  user=1 \
  bio="Développeuse spécialisée en solutions FinTech au Faso" \
  profile_picture_url="https://example.com/fatou.jpg" \
  social_links:='{"github": "FatouOue"}'

# 3. Récupérer l'utilisateur avec son profil
http GET :8000/api/users/1/

# 4. Mettre à jour l'âge de l'utilisateur
http PATCH :8000/api/users/1/ age=29

# 5. Mettre à jour la biographie du profil
http PATCH :8000/api/profiles/1/ \
  bio="Développeuse full-stack senior (spécialisée en services mobiles)"

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

# Réponse (400 Bad Request):
{
  "name": ["Le nom ne peut pas être vide"],
  "email": ["Entrez une adresse e-mail valide"],
  "age": ["L'âge doit être compris entre 1 et 120"]
}
```

-----

## Futures améliorations

  \* [ ] Ajouter l'authentification et l'autorisation
  \* [ ] Implémenter la pagination pour les points de terminaison de liste
  \* [ ] Ajouter des fonctionnalités de filtrage et de recherche
  \* [ ] Créer une documentation d'API avec Swagger/OpenAPI
  \* [ ] Ajouter une limitation de débit (rate limiting)
  \* [ ] Implémenter la mise en cache avec Redis
  \* [ ] Ajouter le téléchargement de fichiers pour les images de profil
  \* [ ] Créer un tableau de bord d'administration


## Contact pour toute question ou commentaire

geniestat.andal@gmail.com
