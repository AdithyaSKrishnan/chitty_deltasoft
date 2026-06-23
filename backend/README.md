# ChittyFinance Backend

## Tech Stack

* Backend: Django + Django REST Framework
* Authentication: JWT Authentication
* Database: SQLite (`db.sqlite3`)
* Frontend: Flutter (`chitty_mobile`)

---

## Prerequisites

* Python 3.13+
* pip

---

## Backend Setup

### 1. Navigate to the backend folder

```bash
cd backend
```

### 2. Install dependencies

```bash
pip install -r requirements.txt
```

### 3. Apply migrations (if required)

```bash
python manage.py migrate
```

### 4. Run the development server

```bash
python manage.py runserver
```

The backend will be available at:

```text
http://127.0.0.1:8000/
```

API Base URL:

```text
http://127.0.0.1:8000/api/
```

---

## Authentication

JWT authentication is used.

Login endpoint:

```text
POST /api/token/
```

Refresh token endpoint:

```text
POST /api/token/refresh/
```

---

## Database

The project currently uses SQLite.

Database file:

```text
backend/db.sqlite3
```

---

## Media Files

Uploaded customer images and documents are stored in:

```text
backend/media/
```

---

## Configuration

No separate `.env` file is currently used.

Project settings are configured in:

```text
backend/chitty_backend/settings.py
```

The Google Maps API key used by the Flutter application is configured in:

```text
chitty_mobile/android/app/src/main/AndroidManifest.xml
```

---

## Running the Flutter Application

Navigate to the Flutter project:

```bash
cd chitty_mobile
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

---

## Repository Structure

```text
project/
├── backend/
│   ├── api/
│   ├── chitty_backend/
│   ├── media/
│   ├── manage.py
│   ├── requirements.txt
│   └── db.sqlite3
│
└── chitty_mobile/
    ├── lib/
    ├── android/
    ├── ios/
    └── pubspec.yaml
```
