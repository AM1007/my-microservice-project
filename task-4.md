# Django Docker Project

A simple containerized Django web application with PostgreSQL database and Nginx reverse proxy.

Project Structure

```
django-docker-project/
├── django_app/           # Django application
│   ├── myproject/        # Django project settings
│   └── manage.py         # Django management script
├── nginx/                # Nginx configuration
│   └── nginx.conf        # Nginx server config
├── docker-compose.yml    # Docker services configuration
├── Dockerfile            # Django container definition
├── docker-entrypoint.sh  # Container startup script
└── requirements.txt      # Python dependencies
```

## Features

Django 4.2+ - Web framework
PostgreSQL 13 - Database
Nginx - Reverse proxy and static file server
Docker Compose - Multi-container orchestration
Gunicorn - WSGI HTTP Server

## Quick Start

Clone the repository:

```bash
git clone <repository-url>
cd django-docker-project
```
Build and run the containers:
bashdocker-compose up -d

Access the application:

Direct Django: http://localhost:8000
Through Nginx: http://localhost
`

Stop the containers:

```bash
bashdocker-compose down
```

## Services

web - Django application (port 8000)
db - PostgreSQL database (port 5432)
nginx - Web server (port 80)

### Environment Variables
The application uses the following environment variables:

POSTGRES_DB - Database name (default: myproject_db)
POSTGRES_USER - Database user (default: postgres)
POSTGRES_PASSWORD - Database password (default: postgres)
DB_HOST - Database host (default: db)
DB_PORT - Database port (default: 5432)

### Development
To view logs:
bashdocker-compose logs web
To access Django admin:

Create a superuser:
bashdocker-compose exec web python manage.py createsuperuser

Visit http://localhost/admin

### Tech Stack

Python 3.11
Django 4.2+
PostgreSQL 13
Nginx
Docker & Docker Compose
Gunicorn