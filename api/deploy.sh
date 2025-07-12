#!/bin/bash

# Скрипт развертывания OneGo Tasks API на VPS
# Использование: ./deploy.sh

set -e

echo "🚀 Начинаем развертывание OneGo Tasks API..."

# Переменные конфигурации
APP_NAME="onegotasks-api"
APP_DIR="/var/www/onegotasks-api"
REPO_URL="https://github.com/SergeyShakirov/OneGo.git"
PORT=3000

# Проверяем, что мы запущены с правами sudo
if [ "$EUID" -ne 0 ]; then
  echo "❌ Пожалуйста, запустите скрипт с sudo"
  exit 1
fi

echo "📦 Обновляем системные пакеты..."
apt update && apt upgrade -y

echo "📦 Устанавливаем Node.js и npm..."
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

echo "📦 Устанавливаем PM2 глобально..."
npm install -g pm2

echo "📦 Устанавливаем Git..."
apt-get install -y git

echo "📁 Создаем директорию для приложения..."
mkdir -p $APP_DIR
cd $APP_DIR

echo "📥 Клонируем репозиторий..."
if [ -d ".git" ]; then
  echo "Обновляем существующий репозиторий..."
  git pull origin master
else
  echo "Клонируем новый репозиторий..."
  git clone $REPO_URL .
fi

echo "📁 Переходим в директорию API..."
cd api

echo "📦 Устанавливаем зависимости..."
npm install --production

echo "⚙️ Создаем файл .env..."
if [ ! -f .env ]; then
  cp .env.example .env
  echo "✅ Создан файл .env из .env.example"
  echo "⚠️ Не забудьте настроить переменные окружения в .env"
fi

echo "🔧 Настраиваем PM2..."
pm2 delete $APP_NAME 2>/dev/null || true
pm2 start ecosystem.config.js --env production
pm2 save
pm2 startup

echo "🔥 Настраиваем firewall..."
ufw allow $PORT/tcp
ufw --force enable

echo "🌐 Настраиваем nginx (опционально)..."
if command -v nginx &> /dev/null; then
  echo "Nginx уже установлен"
else
  apt-get install -y nginx
  
  # Создаем конфигурацию nginx
  cat > /etc/nginx/sites-available/$APP_NAME << EOF
server {
    listen 80;
    server_name your-domain.com;  # Замените на ваш домен

    location / {
        proxy_pass http://localhost:$PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

  # Активируем сайт
  ln -sf /etc/nginx/sites-available/$APP_NAME /etc/nginx/sites-enabled/
  rm -f /etc/nginx/sites-enabled/default
  nginx -t && systemctl reload nginx
  systemctl enable nginx
fi

echo "✅ Развертывание завершено!"
echo ""
echo "📊 Статус приложения:"
pm2 status

echo ""
echo "🔗 API доступно по адресам:"
echo "   - http://localhost:$PORT (локально на сервере)"
echo "   - http://your-server-ip:$PORT (внешний доступ)"
if command -v nginx &> /dev/null; then
  echo "   - http://your-domain.com (через nginx)"
fi

echo ""
echo "📝 Полезные команды:"
echo "   pm2 status          - статус приложения"
echo "   pm2 logs $APP_NAME  - логи приложения"
echo "   pm2 restart $APP_NAME - перезапуск приложения"
echo "   pm2 stop $APP_NAME  - остановка приложения"

echo ""
echo "⚠️ Не забудьте:"
echo "   1. Настроить переменные окружения в $APP_DIR/api/.env"
echo "   2. Настроить домен в конфигурации nginx"
echo "   3. Настроить SSL сертификат (рекомендуется Let's Encrypt)"
