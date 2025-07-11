import 'package:flutter/material.dart';

class SpecialistsPage extends StatefulWidget {
  const SpecialistsPage({super.key});

  @override
  State<SpecialistsPage> createState() => _SpecialistsPageState();
}

class _SpecialistsPageState extends State<SpecialistsPage> {
  String _selectedCategory = 'Все';
  String _selectedRating = 'Все';
  String _searchQuery = '';
  bool _isOnlineOnly = false;
  String _sortBy = 'rating'; // rating, price, distance

  final List<String> _categories = [
    'Все', 'Красота', 'Ремонт', 'IT', 'Обучение', 'Фитнес', 'Уборка'
  ];

  final List<String> _ratings = [
    'Все', '5 звезд', '4+ звезд', '3+ звезд'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchAndFilters(),
            _buildSortingOptions(),
            Expanded(
              child: _buildSpecialistsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Специалисты',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Найдите проверенного исполнителя',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showAdvancedFilters(),
            icon: Icon(
              Icons.tune,
              color: Theme.of(context).primaryColor,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Поиск
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Поиск специалистов...',
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Категории
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade700,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // Онлайн фильтр
          Row(
            children: [
              Switch(
                value: _isOnlineOnly,
                onChanged: (value) => setState(() => _isOnlineOnly = value),
                activeColor: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Только онлайн',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.circle,
                size: 8,
                color: Colors.green,
              ),
              const SizedBox(width: 4),
              Text(
                '${_getOnlineSpecialists().length} онлайн',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortingOptions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            'Сортировка:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSortChip('rating', 'По рейтингу'),
                  const SizedBox(width: 8),
                  _buildSortChip('price', 'По цене'),
                  const SizedBox(width: 8),
                  _buildSortChip('distance', 'По расстоянию'),
                  const SizedBox(width: 8),
                  _buildSortChip('reviews', 'По отзывам'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String value, String label) {
    final isSelected = _sortBy == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) setState(() => _sortBy = value);
      },
      backgroundColor: Colors.white,
      selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        fontSize: 12,
      ),
      side: BorderSide(
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildSpecialistsList() {
    final specialists = _getFilteredSpecialists();
    
    if (specialists.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: specialists.length,
      itemBuilder: (context, index) {
        final specialist = specialists[index];
        return _buildSpecialistCard(specialist);
      },
    );
  }

  Widget _buildSpecialistCard(Map<String, dynamic> specialist) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showSpecialistDetails(specialist),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // Аватар
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(specialist['avatar']),
                        ),
                        if (specialist['isOnline'])
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // Информация
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  specialist['name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              if (specialist['isVerified'])
                                Icon(
                                  Icons.verified,
                                  size: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            specialist['profession'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${specialist['rating']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${specialist['reviewCount']})',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                specialist['isOnline'] ? 'Онлайн' : 'Офлайн',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: specialist['isOnline'] ? Colors.green : Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Специализации
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: (specialist['specializations'] as List<String>).take(3).map((spec) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        spec,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                // Нижняя панель
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      specialist['location'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'от ${specialist['priceFrom']} ₽',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Специалисты не найдены',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Попробуйте изменить параметры поиска',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredSpecialists() {
    List<Map<String, dynamic>> allSpecialists = [
      {
        'id': 1,
        'name': 'Анна Петрова',
        'profession': 'Парикмахер-стилист',
        'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b612b865?w=200&h=200&fit=crop&crop=face',
        'rating': 4.9,
        'reviewCount': 127,
        'specializations': ['Стрижки', 'Окрашивание', 'Укладки', 'Уход за волосами'],
        'location': 'Москва, Центр',
        'priceFrom': 2000,
        'isOnline': true,
        'isVerified': true,
        'category': 'Красота',
        'experience': 5,
      },
      {
        'id': 2,
        'name': 'Дмитрий Козлов',
        'profession': 'Сантехник',
        'avatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&crop=face',
        'rating': 4.8,
        'reviewCount': 89,
        'specializations': ['Ремонт смесителей', 'Установка сантехники', 'Прочистка труб'],
        'location': 'Москва, Юг',
        'priceFrom': 1500,
        'isOnline': false,
        'isVerified': true,
        'category': 'Ремонт',
        'experience': 8,
      },
      {
        'id': 3,
        'name': 'Елена Волкова',
        'profession': 'Веб-разработчик',
        'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&h=200&fit=crop&crop=face',
        'rating': 4.9,
        'reviewCount': 156,
        'specializations': ['Сайты', 'Landing Page', 'Интернет-магазины', 'SEO'],
        'location': 'Удаленно',
        'priceFrom': 15000,
        'isOnline': true,
        'isVerified': true,
        'category': 'IT',
        'experience': 7,
      },
      {
        'id': 4,
        'name': 'Михаил Соколов',
        'profession': 'Персональный тренер',
        'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop&crop=face',
        'rating': 4.7,
        'reviewCount': 73,
        'specializations': ['Силовые тренировки', 'Похудение', 'Реабилитация'],
        'location': 'Москва, Запад',
        'priceFrom': 2500,
        'isOnline': true,
        'isVerified': false,
        'category': 'Фитнес',
        'experience': 4,
      },
      {
        'id': 5,
        'name': 'Ольга Иванова',
        'profession': 'Клининг-менеджер',
        'avatar': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=200&fit=crop&crop=face',
        'rating': 4.8,
        'reviewCount': 92,
        'specializations': ['Генеральная уборка', 'Поддерживающая уборка', 'После ремонта'],
        'location': 'Москва, Север',
        'priceFrom': 3000,
        'isOnline': false,
        'isVerified': true,
        'category': 'Уборка',
        'experience': 6,
      },
      {
        'id': 6,
        'name': 'Артем Смирнов',
        'profession': 'Репетитор английского',
        'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&h=200&fit=crop&crop=face',
        'rating': 4.9,
        'reviewCount': 134,
        'specializations': ['Разговорный английский', 'Подготовка к экзаменам', 'Деловой английский'],
        'location': 'Москва, Центр',
        'priceFrom': 1800,
        'isOnline': true,
        'isVerified': true,
        'category': 'Обучение',
        'experience': 9,
      },
    ];

    List<Map<String, dynamic>> filteredSpecialists = allSpecialists;

    // Фильтрация по категории
    if (_selectedCategory != 'Все') {
      filteredSpecialists = filteredSpecialists.where((specialist) => 
        specialist['category'] == _selectedCategory).toList();
    }

    // Фильтрация только онлайн
    if (_isOnlineOnly) {
      filteredSpecialists = filteredSpecialists.where((specialist) => 
        specialist['isOnline'] == true).toList();
    }

    // Фильтрация по поисковому запросу
    if (_searchQuery.isNotEmpty) {
      filteredSpecialists = filteredSpecialists.where((specialist) =>
        specialist['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
        specialist['profession'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (specialist['specializations'] as List<String>).any((spec) =>
          spec.toLowerCase().contains(_searchQuery.toLowerCase()))).toList();
    }

    // Сортировка
    switch (_sortBy) {
      case 'rating':
        filteredSpecialists.sort((a, b) => b['rating'].compareTo(a['rating']));
        break;
      case 'price':
        filteredSpecialists.sort((a, b) => a['priceFrom'].compareTo(b['priceFrom']));
        break;
      case 'reviews':
        filteredSpecialists.sort((a, b) => b['reviewCount'].compareTo(a['reviewCount']));
        break;
      case 'distance':
        // В реальном приложении здесь была бы сортировка по расстоянию
        break;
    }

    return filteredSpecialists;
  }

  List<Map<String, dynamic>> _getOnlineSpecialists() {
    return _getFilteredSpecialists().where((specialist) => 
      specialist['isOnline'] == true).toList();
  }

  void _showSpecialistDetails(Map<String, dynamic> specialist) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Профиль специалиста
                    Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(specialist['avatar']),
                            ),
                            if (specialist['isOnline'])
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      specialist['name'],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (specialist['isVerified'])
                                    Icon(
                                      Icons.verified,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                ],
                              ),
                              Text(
                                specialist['profession'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${specialist['rating']} (${specialist['reviewCount']} отзывов)',
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Статус и опыт
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: specialist['isOnline'] 
                                ? Colors.green.withValues(alpha: 0.1) 
                                : Colors.grey.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  specialist['isOnline'] ? Icons.circle : Icons.circle_outlined,
                                  color: specialist['isOnline'] ? Colors.green : Colors.grey,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  specialist['isOnline'] ? 'Онлайн' : 'Офлайн',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: specialist['isOnline'] ? Colors.green : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.work_outline,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${specialist['experience']} лет опыта',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Специализации
                    const Text(
                      'Специализации',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (specialist['specializations'] as List<String>).map((spec) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            spec,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Цена
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Стоимость услуг',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'от ${specialist['priceFrom']} ₽',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Действия
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _openChat(specialist);
                            },
                            icon: const Icon(Icons.chat_bubble_outline),
                            label: const Text('Написать'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: Theme.of(context).primaryColor),
                              foregroundColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _bookSpecialist(specialist);
                            },
                            icon: const Icon(Icons.calendar_today),
                            label: const Text('Заказать'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAdvancedFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Дополнительные фильтры',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text('Рейтинг:'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _ratings.map((rating) {
                  return FilterChip(
                    label: Text(rating),
                    selected: _selectedRating == rating,
                    onSelected: (selected) {
                      setState(() {
                        _selectedRating = rating;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedCategory = 'Все';
                          _selectedRating = 'Все';
                          _isOnlineOnly = false;
                          _searchQuery = '';
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Сбросить'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Применить'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openChat(Map<String, dynamic> specialist) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Открытие чата с ${specialist['name']}'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _bookSpecialist(Map<String, dynamic> specialist) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Бронирование услуги у ${specialist['name']}'),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
