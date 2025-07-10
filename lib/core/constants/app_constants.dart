class AppConstants {
  // App Info
  static const String appName = 'OneGo';
  static const String appVersion = '1.0.0';
  
  // API
  static const String baseUrl = 'https://api.onego.app';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String languageKey = 'language';
  static const String themeKey = 'theme';
  
  // Service Categories
  static const List<String> serviceCategories = [
    'Уборка',
    'Ремонт',
    'Красота',
    'Репетиторство',
    'Доставка',
    'Няня',
    'Массаж',
    'Фотография',
    'Дизайн',
    'Другое',
  ];
  
  // Pagination
  static const int pageSize = 20;
  
  // Image Settings
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
}
