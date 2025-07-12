#!/bin/bash

# Скрипт быстрого обновления OneGo Tasks API
# Использование: ./update.sh

set -e

echo "🔄 Обновляем OneGo Tasks API..."

APP_NAME="onegotasks-api"
APP_DIR="/var/www/onegotasks-api"

cd $APP_DIR

echo "📥 Получаем последние изменения..."
git pull origin master

echo "📁 Переходим в директорию API..."
cd api

echo "📦 Обновляем зависимости..."
npm install --production

echo "🔄 Перезапускаем приложение..."
pm2 restart $APP_NAME

echo "✅ Обновление завершено!"

echo ""
echo "📊 Статус приложения:"
pm2 status

echo ""
echo "📝 Логи приложения:"
pm2 logs $APP_NAME --lines 10
