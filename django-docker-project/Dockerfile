# Використовуємо Python 3.11 як базовий образ (альтернативно можна python:3.11-alpine)
FROM python:3.11-slim

# Встановлюємо робочу директорію в контейнері
WORKDIR /app

# Встановлюємо системні залежності
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
        build-essential \
        libpq-dev \
        netcat-traditional \
    && rm -rf /var/lib/apt/lists/*

# Копіюємо файл з залежностями
COPY requirements.txt /app/

# Встановлюємо Python залежності
RUN pip install --no-cache-dir -r requirements.txt

# Копіюємо код застосунку
COPY django_app/ /app/

# Створюємо директорію для статичних файлів
RUN mkdir -p /app/staticfiles

# Відкриваємо порт 8000
EXPOSE 8000

# Створюємо entrypoint скрипт для ініціалізації
COPY docker-entrypoint.sh /app/
RUN chmod +x /app/docker-entrypoint.sh

# Встановлюємо entrypoint
ENTRYPOINT ["/app/docker-entrypoint.sh"]

# Команда за замовчуванням
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "myproject.wsgi:application"]