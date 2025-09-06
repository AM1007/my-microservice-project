# Terraform Infrastructure Project (Lesson 5)

Цей проєкт демонструє створення модульної інфраструктури AWS з використанням Terraform для курсу з Infrastructure as Code (IaC).

## 📋 Опис проєкту

Проєкт реалізує повноцінну інфраструктуру AWS з використанням модульного підходу Terraform, включаючи:

- **S3 Backend** - безпечне зберігання Terraform state файлів з блокуванням через DynamoDB
- **VPC Infrastructure** - мережева інфраструктура з публічними та приватними підмережами
- **ECR Repository** - контейнерний реєстр для Docker образів з автоматичним скануванням

## 🏗️ Структура проєкту

```
├── .gitignore
├── .terraform.lock.hcl
├── README.md
├── assets/
│   ├── screenshot _1.jpg
│   ├── screenshot _2.jpg
│   ├── screenshot _3.jpg
│   ├── screenshot _4.jpg
│   ├── screenshot _5.jpg
│   ├── screenshot _6.jpg
│   └── screenshot _7.jpg
├── backend.tf.disabled
├── main.tf
├── modules/
│   ├── ecr/
│   │   ├── ecr.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── s3-backend/
│   │   ├── dynamodb.tf
│   │   ├── outputs.tf
│   │   ├── s3.tf
│   │   └── variables.tf
│   └── vpc/
│       ├── outputs.tf
│       ├── routes.tf
│       ├── variables.tf
│       └── vpc.tf
└── outputs.tf
```

## 🚀 Швидкий старт

### Передумови

- AWS CLI налаштований з відповідними правами доступу
- Terraform >= 1.0 встановлений
- Git для управління версіями

### Команди для розгортання

1. **Ініціалізація проєкту:**
   ```bash
   terraform init
   ```

2. **Перевірка плану розгортання:**
   ```bash
   terraform plan
   ```

3. **Застосування змін:**
   ```bash
   terraform apply
   ```

4. **Знищення інфраструктури:**
   ```bash
   terraform destroy
   ```

## 📦 Модулі проєкту

### 🗄️ S3-Backend Module (`modules/s3-backend/`)

**Призначення:** Налаштування централізованого зберігання Terraform state файлів.

**Компоненти:**
- **S3 Bucket** з увімкненим версіюванням та шифруванням AES256
- **DynamoDB Table** для блокування state файлів під час виконання операцій
- **Публічний доступ заблокований** для забезпечення безпеки

**Файли:**
- `s3.tf` - конфігурація S3 bucket
- `dynamodb.tf` - налаштування DynamoDB таблиці
- `variables.tf` - змінні модуля
- `outputs.tf` - вихідні значення (bucket name, table name, ARNs)

### 🌐 VPC Module (`modules/vpc/`)

**Призначення:** Створення ізольованої мережевої інфраструктури AWS.

**Компоненти:**
- **VPC** з CIDR блоком 10.0.0.0/16
- **3 публічні підмережі** (10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24)
- **3 приватні підмережі** (10.0.4.0/24, 10.0.5.0/24, 10.0.6.0/24)
- **Internet Gateway** для публічного доступу
- **NAT Gateway** для вихідного трафіку з приватних підмереж
- **Route Tables** для налаштування маршрутизації

**Файли:**
- `vpc.tf` - основна конфігурація VPC та підмереж
- `routes.tf` - налаштування маршрутизації
- `variables.tf` - змінні модуля
- `outputs.tf` - інформація про створені ресурси

### 🐳 ECR Module (`modules/ecr/`)

**Призначення:** Управління Docker образами в AWS Elastic Container Registry.

**Компоненти:**
- **ECR Repository** з можливістю зміни тегів (MUTABLE)
- **Автоматичне сканування** образів на наявність вразливостей
- **Repository Policy** для контролю доступу
- **Lifecycle Policy** - збереження останніх 10 образів

**Файли:**
- `ecr.tf` - конфігурація ECR репозиторію та політик
- `variables.tf` - змінні модуля
- `outputs.tf` - URL та метадані репозиторію

## ⚙️ Конфігурація

### Основні змінні

- `aws_region` - AWS регіон (за замовчуванням: us-west-2)
- `environment` - середовище розгортання (за замовчуванням: dev)
- `bucket_name` - ім'я S3 bucket для state файлів
- `vpc_cidr_block` - CIDR блок для VPC
- `ecr_name` - ім'я ECR репозиторію

### Backend конфігурація

Проєкт підготовлений для використання S3 backend (файл `backend.tf.disabled`). Після створення S3 bucket та DynamoDB table:

1. Перейменуйте `backend.tf.disabled` в `backend.tf`
2. Оновіть конфігурацію з правильними значеннями
3. Виконайте `terraform init` для міграції state

## 🔒 Безпека

- S3 bucket з увімкненим шифруванням AES256
- Публічний доступ до S3 bucket заблокований
- ECR автоматично сканує образи на вразливості
- DynamoDB забезпечує консистентність state файлів

## 📸 Скріншоти

Проєкт включає скріншоти процесу розгортання та результатів в папці `assets/`.

## 🤝 Внесок у проєкт

Цей проєкт створений як частина навчального курсу з Infrastructure as Code. Він демонструє best practices для:

- Модульної архітектури Terraform
- Управління state файлами
- Створення масштабованої мережевої інфраструктури
- Безпечного зберігання контейнерних образів

## 📄 Ліцензія

Проєкт створений в навчальних цілях.