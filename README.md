# OneGo - Платформа поиска специалистов и задач

![OneGo Logo](https://via.placeholder.com/200x100/4f46e5/ffffff?text=OneGo)

OneGo - это современная платформа для поиска специалистов различных направлений и размещения задач. Проект включает мобильное приложение на Flutter и API сервер на Node.js.

## 🚀 Возможности

### 📱 Мобильное приложение (Flutter)
- **Поиск специалистов** - более 50 категорий услуг
- **Система задач** - создание и управление задачами
- **Чаты и сообщения** - общение со специалистами
- **Профиль пользователя** - рейтинги, отзывы, портфолио
- **Уведомления** - push-уведомления о новых сообщениях
- **Геолокация** - поиск специалистов поблизости

### 🔧 API Сервер (Node.js)
- **RESTful API** - полный CRUD для задач
- **Фильтрация и сортировка** - по категориям, цене, рейтингу
- **Система откликов** - отклики на задачи
- **Масштабируемость** - готов для продакшн среды

## 📂 Структура проекта

```
OneGo/
├── 📱 one_go/                 # Flutter приложение
│   ├── lib/
│   │   ├── features/          # Модули приложения
│   │   │   ├── tasks/         # Управление задачами
│   │   │   ├── chats/         # Система чатов
│   │   │   ├── specialists/   # Поиск специалистов
│   │   │   ├── profile/       # Профиль пользователя
│   │   │   └── auth/          # Аутентификация
│   │   ├── core/              # Базовая функциональность
│   │   └── shared/            # Общие компоненты
│   └── pubspec.yaml
├── 🔧 api/                    # Node.js API сервер  
│   ├── server.js              # Основной файл сервера
│   ├── package.json           # Зависимости Node.js
│   ├── deploy.sh              # Скрипт развертывания
│   └── ecosystem.config.js    # Конфигурация PM2
├── 📖 DEPLOYMENT.md           # Инструкция по развертыванию
└── 📋 PROJECT_SUMMARY.md      # Описание проекта
```

## 🛠 Технологический стек

### Frontend (Flutter)
- **Flutter 3.24+** - кроссплатформенная разработка
- **Bloc Pattern** - управление состоянием
- **Dio** - HTTP клиент для API запросов
- **GetIt + Injectable** - dependency injection
- **Firebase** - аутентификация и уведомления
- **JSON Serialization** - автоматическая сериализация моделей

### Backend (Node.js)
- **Express.js** - веб-фреймворк
- **UUID** - генерация уникальных ID
- **CORS** - поддержка кроссдоменных запросов
- **PM2** - менеджер процессов для продакшн

### DevOps
- **PM2** - управление процессами
- **Nginx** - прокси сервер и балансировщик
- **Let's Encrypt** - бесплатные SSL сертификаты
- **Ubuntu VPS** - развертывание в облаке

## 🚀 Быстрый старт

### Локальная разработка

#### 1. API Сервер
```bash
cd api
npm install
npm start
```
API будет доступен на http://localhost:3000

#### 2. Flutter приложение
```bash
cd one_go
flutter pub get
flutter run
```

### Развертывание на VPS

```bash
# Скачайте и запустите скрипт развертывания
wget https://raw.githubusercontent.com/SergeyShakirov/OneGo/master/api/deploy.sh
chmod +x deploy.sh
sudo ./deploy.sh
```

Подробная инструкция в [DEPLOYMENT.md](DEPLOYMENT.md)

## 📱 Скриншоты приложения

| Главная | Задачи | Специалисты | Чаты |
|---------|--------|-------------|------|
| ![Главная](https://via.placeholder.com/200x350/f3f4f6/374151?text=Главная) | ![Задачи](https://via.placeholder.com/200x350/f3f4f6/374151?text=Задачи) | ![Специалисты](https://via.placeholder.com/200x350/f3f4f6/374151?text=Специалисты) | ![Чаты](https://via.placeholder.com/200x350/f3f4f6/374151?text=Чаты) |

## 🔧 API Документация

### Основные эндпоинты

#### Задачи
- `GET /api/tasks` - Получить все задачи
- `GET /api/tasks/:id` - Получить задачу по ID  
- `POST /api/tasks` - Создать новую задачу
- `PUT /api/tasks/:id` - Обновить задачу
- `DELETE /api/tasks/:id` - Удалить задачу
- `POST /api/tasks/:id/respond` - Откликнуться на задачу

#### Параметры запросов
```
GET /api/tasks?category=Веб-разработка&sortBy=price&page=1&limit=10
```

Подробная документация в [api/README.md](api/README.md)

## 🧪 Тестирование

### API
```bash
# Получить все задачи
curl http://localhost:3000/api/tasks

# Создать задачу
curl -X POST http://localhost:3000/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title":"Тест","description":"Описание","category":"IT","price":50000}'
```

### Flutter
```bash
cd one_go
flutter test
```

## 📈 Планы развития

- [ ] **Реалтайм чаты** - WebSocket соединения
- [ ] **Система платежей** - интеграция с платежными системами  
- [ ] **Уведомления** - push и email уведомления
- [ ] **Геолокация** - поиск по расстоянию
- [ ] **Файлы** - загрузка и хранение файлов
- [ ] **Отзывы и рейтинги** - система репутации
- [ ] **Мобильные приложения** - iOS и Android релизы

## 🤝 Вклад в проект

1. Fork репозитория
2. Создайте ветку для новой функции (`git checkout -b feature/new-feature`)
3. Commit изменения (`git commit -am 'Add new feature'`)
4. Push в ветку (`git push origin feature/new-feature`)
5. Создайте Pull Request

## 📄 Лицензия

Этот проект распространяется под лицензией MIT. См. файл [LICENSE](LICENSE) для подробностей.

## 🆘 Поддержка

- **Документация**: [DEPLOYMENT.md](DEPLOYMENT.md)
- **Issues**: [GitHub Issues](https://github.com/SergeyShakirov/OneGo/issues)
- **API Docs**: [api/README.md](api/README.md)

---

<div align="center">

**OneGo** - найди своего специалиста 🎯

[![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?logo=flutter)](https://flutter.dev)
[![Node.js](https://img.shields.io/badge/Node.js-18+-339933?logo=node.js)](https://nodejs.org)
[![Express](https://img.shields.io/badge/Express-4.18+-000000?logo=express)](https://expressjs.com)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

</div>
