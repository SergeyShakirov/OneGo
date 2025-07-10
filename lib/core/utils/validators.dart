class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email обязателен';
    }
    
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Введите корректный email';
    }
    
    return null;
  }
  
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пароль обязателен';
    }
    
    if (value.length < 6) {
      return 'Пароль должен содержать минимум 6 символов';
    }
    
    return null;
  }
  
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName обязателен';
    }
    return null;
  }
  
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Номер телефона обязателен';
    }
    
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
      return 'Введите корректный номер телефона';
    }
    
    return null;
  }
  
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Подтверждение пароля обязательно';
    }
    
    if (value != password) {
      return 'Пароли не совпадают';
    }
    
    return null;
  }
  
  static String? price(String? value) {
    if (value == null || value.isEmpty) {
      return 'Цена обязательна';
    }
    
    final price = double.tryParse(value);
    if (price == null || price <= 0) {
      return 'Введите корректную цену';
    }
    
    return null;
  }
}
