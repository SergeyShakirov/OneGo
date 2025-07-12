# OneGo Tasks API

REST API сервер для приложения OneGo Tasks.

## Возможности

- CRUD операции для задач
- Фильтрация и сортировка задач
- Система откликов на задачи
- JSON API

## Установка и запуск

### Локально

```bash
cd api
npm install
npm start
```

### На VPS

```bash
# Клонирование репозитория
git clone https://github.com/SergeyShakirov/OneGo.git
cd OneGo/api

# Установка зависимостей
npm install

# Установка PM2 для управления процессами
npm install -g pm2

# Запуск через PM2
pm2 start ecosystem.config.js
```

## API Endpoints

### Задачи

- `GET /api/tasks` - Получить все задачи с фильтрацией и сортировкой
  - Query параметры:
    - `category` - фильтр по категории
    - `sortBy` - сортировка (дата создания, цена, популярность, рейтинг)
    - `page` - номер страницы (по умолчанию 1)
    - `limit` - количество элементов на странице (по умолчанию 10)

- `GET /api/tasks/:id` - Получить задачу по ID

- `POST /api/tasks` - Создать новую задачу
  - Body: JSON с полями title, description, category, price, deadline, skills, isUrgent

- `PUT /api/tasks/:id` - Обновить задачу

- `DELETE /api/tasks/:id` - Удалить задачу

- `POST /api/tasks/:id/respond` - Откликнуться на задачу

## Переменные окружения

Создайте файл `.env` с следующими переменными:

```
PORT=3000
NODE_ENV=production
```

## Развертывание

API готов для развертывания на любом VPS с Node.js. 
Рекомендуется использовать PM2 для управления процессами.

## Структура данных

### Task
```json
{
  "id": "string",
  "title": "string",
  "description": "string", 
  "category": "string",
  "price": "number",
  "deadline": "string",
  "authorId": "string",
  "authorName": "string",
  "authorRating": "number",
  "responsesCount": "number",
  "isUrgent": "boolean",
  "skills": ["string"],
  "createdAt": "string",
  "updatedAt": "string"
}
```
