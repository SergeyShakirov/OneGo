# 🚀 Инструкция по развертыванию OneGo Tasks на VPS

## 📋 Подготовка VPS сервера

### Системные требования
- Ubuntu 20.04 LTS или новее  
- 1 ГБ RAM (минимум)
- 10 ГБ свободного места
- Node.js 18+ 

### 1. Подключение к серверу
```bash
ssh root@your-server-ip
```

### 2. Обновление системы
```bash
apt update && apt upgrade -y
```

## 🔧 Автоматическая установка

### Быстрое развертывание (рекомендуется)
```bash
# Скачиваем и запускаем скрипт развертывания
wget https://raw.githubusercontent.com/SergeyShakirov/OneGo/master/api/deploy.sh
chmod +x deploy.sh
sudo ./deploy.sh
```

Скрипт автоматически:
- Установит Node.js 18, npm, PM2, Git
- Склонирует репозиторий
- Установит зависимости
- Настроит PM2 для автозапуска
- Настроит nginx (опционально)
- Откроет необходимые порты в firewall

## ⚙️ Ручная установка

### 1. Установка Node.js
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### 2. Установка PM2
```bash
sudo npm install -g pm2
```

### 3. Клонирование репозитория
```bash
cd /var/www
sudo git clone https://github.com/SergeyShakirov/OneGo.git
cd OneGo/api
```

### 4. Установка зависимостей
```bash
sudo npm install --production
```

### 5. Настройка окружения
```bash
sudo cp .env.example .env
sudo nano .env
```

Настройте переменные:
```env
PORT=3000
NODE_ENV=production
```

### 6. Запуск приложения
```bash
sudo pm2 start ecosystem.config.js --env production
sudo pm2 save
sudo pm2 startup
```

## 🌐 Настройка Nginx (рекомендуется)

### 1. Установка Nginx
```bash
sudo apt install nginx -y
```

### 2. Создание конфигурации
```bash
sudo nano /etc/nginx/sites-available/onegotasks
```

Содержимое файла:
```nginx
server {
    listen 80;
    server_name your-domain.com;  # Замените на ваш домен

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### 3. Активация сайта
```bash
sudo ln -s /etc/nginx/sites-available/onegotasks /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx
sudo systemctl enable nginx
```

## 🔒 Настройка SSL (Let's Encrypt)

```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d your-domain.com
```

## 🔥 Настройка Firewall

```bash
sudo ufw allow 22     # SSH
sudo ufw allow 80     # HTTP
sudo ufw allow 443    # HTTPS
sudo ufw allow 3000   # API (если нужен прямой доступ)
sudo ufw --force enable
```

## 📊 Управление приложением

### Основные команды PM2
```bash
pm2 status                    # Статус приложений
pm2 logs onegotasks-api       # Просмотр логов
pm2 restart onegotasks-api    # Перезапуск
pm2 stop onegotasks-api       # Остановка
pm2 delete onegotasks-api     # Удаление из PM2
```

### Мониторинг
```bash
pm2 monit                     # Интерактивный мониторинг
pm2 logs --lines 50          # Последние 50 строк логов
```

## 🔄 Обновление приложения

### Автоматическое обновление
```bash
cd /var/www/OneGo/api
sudo ./update.sh
```

### Ручное обновление
```bash
cd /var/www/OneGo
sudo git pull origin master
cd api
sudo npm install --production
sudo pm2 restart onegotasks-api
```

## 🧪 Тестирование API

### Проверка работоспособности
```bash
curl http://localhost:3000/api/tasks
curl http://your-domain.com/api/tasks
```

### Создание тестовой задачи
```bash
curl -X POST http://localhost:3000/api/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Тестовая задача",
    "description": "Описание тестовой задачи",
    "category": "Веб-разработка",
    "price": 50000,
    "deadline": "7 дней",
    "skills": ["Node.js", "API"]
  }'
```

## 📱 Настройка Flutter приложения

### Обновление API URL в приложении
В файле `one_go/lib/core/config/api_config.dart`:
```dart
static const String _prodUrl = 'https://your-domain.com'; // Ваш домен
```

### Сборка релизной версии
```bash
cd one_go
flutter build apk --release
flutter build web --release
```

## 🔍 Отладка проблем

### Проверка статуса сервисов
```bash
sudo systemctl status nginx
pm2 status
```

### Просмотр логов
```bash
pm2 logs onegotasks-api
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log
```

### Проверка портов
```bash
sudo netstat -tlnp | grep :3000
sudo netstat -tlnp | grep :80
```

## 🆘 Устранение неполадок

### API не отвечает
1. Проверьте статус PM2: `pm2 status`
2. Перезапустите приложение: `pm2 restart onegotasks-api`
3. Проверьте логи: `pm2 logs onegotasks-api`

### Nginx показывает 502 Bad Gateway
1. Убедитесь, что API запущен: `pm2 status`
2. Проверьте конфигурацию nginx: `sudo nginx -t`
3. Перезапустите nginx: `sudo systemctl restart nginx`

### Проблемы с SSL
1. Обновите сертификат: `sudo certbot renew`
2. Проверьте статус: `sudo certbot certificates`

## 📞 Поддержка

После успешного развертывания ваш API будет доступен по адресам:
- **Локально на сервере**: http://localhost:3000
- **Внешний доступ**: http://your-server-ip:3000  
- **Через nginx**: http://your-domain.com
- **Через SSL**: https://your-domain.com

Все эндпоинты API документированы в файле `api/README.md`.
