#!/bin/bash

# Очікуємо доступності бази даних
echo "Очікуємо підключення до PostgreSQL..."

while ! nc -z db 5432; do
  sleep 0.1
done

echo "PostgreSQL запущений"

# Виконуємо міграції
echo "Виконуємо міграції Django..."
python manage.py migrate --noinput

# Збираємо статичні файли
echo "Збираємо статичні файли..."
python manage.py collectstatic --noinput

# Виконуємо передану команду
exec "$@"