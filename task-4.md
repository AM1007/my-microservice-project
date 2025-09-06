# Django + PostgreSQL + Nginx в Docker 🐳

Багатосервісний веб-проєкт на Django з використанням контейнеризації Docker. Проєкт включає Django веб-застосунок, базу даних PostgreSQL та веб-сервер Nginx для обробки статичних файлів та проксування запитів.

[На головну](./README.md)

## 🚀 Особливості проєкту

- **Django 4.2+** — сучасний веб-фреймворк Python
- **PostgreSQL 15** — надійна реляційна база даних
- **Nginx** — високопродуктивний веб-сервер та зворотний проксі
- **Docker Compose** — оркестрація багатоконтейнерного застосунку
- **Gunicorn** — WSGI HTTP-сервер для production

## 📁 Структура проєкту

```
django-docker-project/
├── Dockerfile                 # Образ для Django застосунку
├── docker-compose.yml         # Конфігурація сервісів
├── docker-entrypoint.sh       # Скрипт ініціалізації Django
├── requirements.txt           # Python залежності
├── django_app/               # Django застосунок
│   ├── manage.py
│   └── myproject/
│       ├── __init__.py
│       ├── asgi.py
│       ├── settings.py        # Налаштування Django
│       ├── urls.py
│       └── wsgi.py
└── nginx/
    └── nginx.conf            # Конфігурація Nginx
```

## 🛠 Технічні вимоги

- Docker Engine 20.10+
- Docker Compose 2.0+
- Git

## ⚡ Швидкий старт

### 1. Клонування репозиторію

```bash
git clone <your-repository-url>
cd django-docker-project
```

### 2. Запуск проєкту

```bash
# Збірка та запуск всіх сервісів
docker-compose up -d

# Перегляд логів
docker-compose logs -f
```

### 3. Перевірка роботи

Відкрийте браузер та перейдіть за адресою: http://localhost

Ви побачите привітальне повідомлення: "Привіт! Django працює з PostgreSQL та Nginx!"

## 🐘 Робота з базою даних

### Доступ до PostgreSQL

```bash
# Підключення до бази даних
docker-compose exec db psql -U postgres -d myproject_db

# Виконання міграцій Django
docker-compose exec web python manage.py migrate

# Створення суперкористувача
docker-compose exec web python manage.py createsuperuser
```

### Адміністрування

Доступ до Django Admin: http://localhost/admin/

## 📊 Сервіси проєкту

| Сервіс | Порт | Опис |
|--------|------|------|
| `nginx` | 80 | Веб-сервер, статичні файли, проксі |
| `web` | 8000 | Django застосунок (Gunicorn) |
| `db` | 5432 | PostgreSQL база даних |

## 🔧 Конфігурація середовища

Основні змінні середовища в `docker-compose.yml`:

```yaml
environment:
  - POSTGRES_DB=myproject_db
  - POSTGRES_USER=postgres
  - POSTGRES_PASSWORD=postgres
  - DB_HOST=db
  - DB_PORT=5432
```

## 📝 Корисні команди

### Управління контейнерами

```bash
# Запуск сервісів
docker-compose up -d

# Зупинка сервісів
docker-compose down

# Перезбудова образів
docker-compose build --no-cache

# Перегляд статусу
docker-compose ps
```

### Django команди

```bash
# Виконання міграцій
docker-compose exec web python manage.py migrate

# Збирання статичних файлів
docker-compose exec web python manage.py collectstatic

# Доступ до Django shell
docker-compose exec web python manage.py shell
```

### Логи та діагностика

```bash
# Перегляд логів всіх сервісів
docker-compose logs

# Логи конкретного сервіса
docker-compose logs web
docker-compose logs db
docker-compose logs nginx

# Інтерактивний доступ до контейнера
docker-compose exec web bash
```

## 🔒 Безпека та Production

⚠️ **Важливо для production:**

1. **Змініть SECRET_KEY** в `settings.py`
2. **Встановіть DEBUG = False**
3. **Налаштуйте ALLOWED_HOSTS**
4. **Використовуйте змінні середовища** для паролів
5. **Додайте SSL/TLS** сертифікати

## 🐛 Усунення несправностей

### Перевірка health check PostgreSQL

```bash
docker-compose exec db pg_isready -U postgres
```

### Підключення до PostgreSQL не працює

1. Переконайтеся, що контейнер `db` запущений
2. Перевірте health check статус
3. Перегляньте логи бази даних

### Nginx не обслуговує статичні файли

1. Виконайте `python manage.py collectstatic`
2. Перевірте том `static_volume` в docker-compose.yml

## 🤝 Контрибуція

Для покращення проєкту:

1. Створіть форк репозиторію
2. Створіть feature-гілку: `git checkout -b feature/amazing-feature`
3. Зафіксуйте зміни: `git commit -m 'Add amazing feature'`
4. Завантажте зміни: `git push origin feature/amazing-feature`
5. Створіть Pull Request

## 📜 Ліцензія

Цей проєкт створено в навчальних цілях.

## 📞 Підтримка

Якщо у вас виникли питання або проблеми, створіть Issue в репозиторії.

---

**🎯 Домашнє завдання виконано успішно!** 

Проєкт демонструє правильну контейнеризацію Django застосунку з PostgreSQL та Nginx, готовий до розгортання у production середовищі.