#!/bin/bash

# Быстрое развертывание OneGo API на VPS
# Использование: curl -sSL https://raw.githubusercontent.com/SergeyShakirov/OneGo/master/quick-deploy.sh | bash

set -e

echo "🚀 Начинаем быстрое развертывание OneGo Tasks API..."

# Проверяем права root
if [ "$EUID" -ne 0 ]; then
  echo "❌ Пожалуйста, запустите с sudo:"
  echo "curl -sSL https://raw.githubusercontent.com/SergeyShakirov/OneGo/master/quick-deploy.sh | sudo bash"
  exit 1
fi

# Установка зависимостей
echo "📦 Устанавливаем зависимости..."
apt update
apt install -y curl git

# Установка Node.js
echo "📦 Устанавливаем Node.js 18..."
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Установка PM2
echo "📦 Устанавливаем PM2..."
npm install -g pm2

# Клонирование репозитория
echo "📥 Клонируем репозиторий..."
cd /var/www
rm -rf OneGo
git clone https://github.com/SergeyShakirov/OneGo.git
cd OneGo/api

# Установка зависимостей проекта
echo "📦 Устанавливаем зависимости проекта..."
npm install --production

# Создание .env файла
echo "⚙️ Создаем конфигурацию..."
cp .env.example .env

# Запуск через PM2
echo "🚀 Запускаем API сервер..."
pm2 delete onegotasks-api 2>/dev/null || true
pm2 start ecosystem.config.js --env production
pm2 save
pm2 startup

# Настройка firewall
echo "🔥 Настраиваем firewall..."
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 3000/tcp
ufw --force enable

echo "✅ Развертывание завершено!"
echo ""
echo "📊 Статус приложения:"
pm2 status
echo ""
echo "🔗 API доступно по адресу: http://$(curl -s ifconfig.me):3000"
echo "📋 Тестирование: curl http://localhost:3000/api/tasks"
echo ""
echo "📝 Полезные команды:"
echo "  pm2 status                    - статус приложений"
echo "  pm2 logs onegotasks-api       - логи приложения"
echo "  pm2 restart onegotasks-api    - перезапуск"
echo "  cd /var/www/OneGo/api && ./update.sh - обновление"
