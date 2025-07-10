# OneGo - Flutter Service Marketplace

A modern Flutter application for connecting service providers with customers who need various services.

## 📱 Features

- **User Authentication** - Secure login/register for customers and service providers
- **Service Browsing** - Search and browse services by categories
- **Service Provider Profiles** - Detailed profiles with ratings and reviews
- **Booking System** - Easy booking and management of services
- **In-App Chat** - Direct communication between customers and providers
- **Payment Integration** - Secure payment processing
- **Push Notifications** - Real-time updates
- **Multi-language Support** - Russian/English

## 🏗️ Architecture

- **Clean Architecture** - Separation of concerns with clear layers
- **BLoC Pattern** - State management with flutter_bloc
- **Dependency Injection** - Using GetIt and Injectable
- **GoRouter** - Declarative routing
- **Form Validation** - Custom validators with proper error handling

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/onego-flutter-app.git
cd onego-flutter-app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code:
```bash
dart run build_runner build
```

4. Run the app:
```bash
# Web
flutter run -d chrome

# Android
flutter run -d emulator-5554

# iOS
flutter run -d ios
```

## 📁 Project Structure

```
lib/
├── core/
│   ├── di/                 # Dependency injection
│   ├── error/              # Error handling
│   ├── theme/              # App theme
│   └── utils/              # Utilities and validators
├── features/
│   ├── auth/               # Authentication feature
│   ├── home/               # Home screen
│   ├── profile/            # User profile
│   ├── services/           # Service browsing
│   ├── booking/            # Booking system
│   └── chat/               # In-app messaging
├── shared/
│   ├── models/             # Data models
│   └── widgets/            # Reusable widgets
└── main.dart               # App entry point
```

## �️ Tech Stack

- **Flutter** - UI framework
- **Dart** - Programming language
- **BLoC** - State management
- **GetIt** - Dependency injection
- **GoRouter** - Navigation
- **Dio** - HTTP client
- **Hive** - Local storage
- **Firebase** - Backend services (optional)
- **Injectable** - Code generation for DI

## 🔧 Configuration

### Android

- **Min SDK**: 23 (Android 6.0)
- **Target SDK**: Latest
- **NDK Version**: 27.0.12077973

### iOS

- **Min iOS Version**: 12.0
- **Swift Version**: 5.0

## 📱 Screenshots

[Add screenshots of your app here]

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **OneGo Team** - *Initial work*

## � Acknowledgments

- Flutter team for the amazing framework
- The open-source community for the excellent packages
- All contributors who make this project better

## 📞 Support

For support, email developer@onego.com or create an issue in this repository.

---

**Made with ❤️ using Flutter**
- Детальная информация об услуге
- Рейтинги и отзывы

### 📅 Бронирование
- Выбор даты и времени
- Комментарии к заказу
- Детали оплаты
- Подтверждение бронирования

### 💬 Чат
- Общение между клиентами и исполнителями
- Список чатов
- Отправка сообщений в реальном времени
- История сообщений

### 👤 Профиль
- Личная информация пользователя
- Статистика (рейтинг, заказы, отзывы)
- История заказов
- Настройки приложения

## Архитектура

Приложение построено с использованием Clean Architecture и следующих паттернов:

- **BLoC** - для управления состоянием
- **GoRouter** - для навигации
- **GetIt** - для внедрения зависимостей
- **Dio** - для работы с API
- **Hive** - для локального хранения данных

## Структура проекта

```
lib/
├── core/                 # Основные компоненты
│   ├── constants/        # Константы приложения
│   ├── error/           # Обработка ошибок
│   ├── network/         # Конфигурация сети
│   ├── router/          # Маршрутизация
│   ├── theme/           # Темы и стили
│   └── utils/           # Утилиты
├── features/            # Функциональные модули
│   ├── auth/            # Аутентификация
│   ├── home/            # Главная страница
│   ├── services/        # Услуги
│   ├── booking/         # Бронирование
│   ├── profile/         # Профиль
│   └── chat/            # Чат
└── shared/              # Общие компоненты
    ├── models/          # Модели данных
    └── widgets/         # Виджеты
```

## Технологии

- **Flutter 3.7+** - фреймворк для кроссплатформенной разработки
- **Dart 3.0+** - язык программирования
- **Material Design 3** - дизайн система
- **Firebase** - аутентификация и уведомления
- **REST API** - взаимодействие с сервером

## Установка и запуск

### Предварительные требования

- Flutter SDK 3.7 или выше
- Dart SDK 3.0 или выше
- Android Studio / VS Code
- Android SDK / Xcode (для соответствующих платформ)

### Установка

1. Клонируйте репозиторий:
```bash
git clone https://github.com/your-repo/one_go.git
cd one_go
```

2. Установите зависимости:
```bash
flutter pub get
```

3. Сгенерируйте код (если необходимо):
```bash
flutter packages pub run build_runner build
```

4. Запустите приложение:
```bash
flutter run
```

## Сборка

### Android
```bash
flutter build apk --release
# или
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Конфигурация

### API
Настройте базовый URL API в файле `lib/core/constants/app_constants.dart`:
```dart
static const String baseUrl = 'https://your-api-url.com';
```

### Firebase
1. Создайте проект в Firebase Console
2. Добавьте конфигурационные файлы:
   - `android/app/google-services.json` для Android
   - `ios/Runner/GoogleService-Info.plist` для iOS

## Категории услуг

- 🧹 Уборка
- 🔧 Ремонт
- 💄 Красота
- 📚 Репетиторство
- 🚚 Доставка
- 👶 Няня
- 💆 Массаж
- 📸 Фотография
- 🎨 Дизайн
- ⚙️ Другое

## Участие в разработке

1. Форкните репозиторий
2. Создайте ветку для новой функции (`git checkout -b feature/amazing-feature`)
3. Зафиксируйте изменения (`git commit -m 'Add amazing feature'`)
4. Отправьте в ветку (`git push origin feature/amazing-feature`)
5. Откройте Pull Request

## Лицензия

Этот проект лицензирован под MIT License - см. файл [LICENSE](LICENSE) для подробностей.

## Авторы

- Разработчик - [@your-username](https://github.com/your-username)

## Поддержка

Если у вас есть вопросы или предложения, создайте issue в репозитории или свяжитесь с нами по email: support@onego.app
