class ApiConfig {
  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );
  
  static const String _prodUrl = 'https://api.onegotasks.com'; // Замените на ваш домен
  
  static String get baseUrl {
    // В продакшене используем продакшн URL
    const isProd = bool.fromEnvironment('dart.vm.product');
    return isProd ? _prodUrl : _baseUrl;
  }
  
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // API endpoints
  static const String tasksPath = '/api/tasks';
}
