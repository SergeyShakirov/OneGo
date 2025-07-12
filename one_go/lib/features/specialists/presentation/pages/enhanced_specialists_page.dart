import 'package:flutter/material.dart';

class SpecialistsPage extends StatefulWidget {
  const SpecialistsPage({super.key});

  @override
  State<SpecialistsPage> createState() => _SpecialistsPageState();
}

class _SpecialistsPageState extends State<SpecialistsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Все';
  String _selectedSort = 'Рейтинг';
  double _minPrice = 0;
  double _maxPrice = 10000;

  final List<String> _categories = [
    'Все',
    'Веб-разработка',
    'Мобильная разработка',
    'Дизайн',
    'Маркетинг',
    'Консультации',
    'Копирайтинг',
    'Переводы',
  ];

  final List<String> _sortOptions = [
    'Рейтинг',
    'Цена (по возрастанию)',
    'Цена (по убыванию)',
    'Количество отзывов',
    'Время отклика',
  ];

  // Mock data для специалистов
  final List<Map<String, dynamic>> _specialists = [
    {
      'id': '1',
      'name': 'Анна Петрова',
      'title': 'Flutter разработчик',
      'category': 'Мобильная разработка',
      'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b612b93c?w=200&h=200&fit=crop&crop=face',
      'rating': 4.9,
      'reviewsCount': 127,
      'completedProjects': 89,
      'hourlyRate': 3500,
      'responseTime': '1 час',
      'isOnline': true,
      'skills': ['Flutter', 'Dart', 'Firebase', 'REST API', 'UI/UX'],
      'description': 'Опытный Flutter разработчик с 5+ годами опыта. Создаю качественные мобильные приложения для iOS и Android.',
      'location': 'Москва',
      'portfolio': [
        'https://images.unsplash.com/photo-1551650975-87deedd944c3?w=300&h=200&fit=crop',
        'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=300&h=200&fit=crop',
      ],
    },
    {
      'id': '2',
      'name': 'Дмитрий Козлов',
      'title': 'Full-stack веб-разработчик',
      'category': 'Веб-разработка',
      'avatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&crop=face',
      'rating': 4.8,
      'reviewsCount': 93,
      'completedProjects': 156,
      'hourlyRate': 4200,
      'responseTime': '30 мин',
      'isOnline': true,
      'skills': ['React', 'Node.js', 'Python', 'PostgreSQL', 'AWS'],
      'description': 'Создаю современные веб-приложения с использованием актуальных технологий. Специализируюсь на SaaS решениях.',
      'location': 'Санкт-Петербург',
      'portfolio': [
        'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=300&h=200&fit=crop',
        'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=300&h=200&fit=crop',
      ],
    },
    {
      'id': '3',
      'name': 'Елена Волкова',
      'title': 'UI/UX дизайнер',
      'category': 'Дизайн',
      'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&h=200&fit=crop&crop=face',
      'rating': 5.0,
      'reviewsCount': 67,
      'completedProjects': 124,
      'hourlyRate': 2800,
      'responseTime': '2 часа',
      'isOnline': false,
      'skills': ['Figma', 'Adobe XD', 'Sketch', 'Prototyping', 'User Research'],
      'description': 'Создаю интуитивные и красивые интерфейсы. Провожу UX исследования и тестирования для оптимизации пользовательского опыта.',
      'location': 'Екатеринбург',
      'portfolio': [
        'https://images.unsplash.com/photo-1558655146-9f40138edfeb?w=300&h=200&fit=crop',
        'https://images.unsplash.com/photo-1572044162444-ad60f128bdea?w=300&h=200&fit=crop',
      ],
    },
    {
      'id': '4',
      'name': 'Михаил Сидоров',
      'title': 'Digital маркетолог',
      'category': 'Маркетинг',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop&crop=face',
      'rating': 4.7,
      'reviewsCount': 84,
      'completedProjects': 203,
      'hourlyRate': 2200,
      'responseTime': '1 час',
      'isOnline': true,
      'skills': ['Google Ads', 'Facebook Ads', 'Analytics', 'SEO', 'Content Marketing'],
      'description': 'Помогаю бизнесу расти через эффективные рекламные кампании и маркетинговые стратегии.',
      'location': 'Новосибирск',
      'portfolio': [
        'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=300&h=200&fit=crop',
        'https://images.unsplash.com/photo-1553028826-f4804a6dba3b?w=300&h=200&fit=crop',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchAndFilters(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAllSpecialistsTab(),
                  _buildFavoritesTab(),
                  _buildRecentTab(),
                ],
              ),
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
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Найдите лучших экспертов для вашего проекта',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Поиск специалистов...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.tune),
                onPressed: _showFiltersDialog,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Категория',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _categories.map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(category, style: const TextStyle(fontSize: 14)),
                  )).toList(),
                  onChanged: (value) => setState(() => _selectedCategory = value!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedSort,
                  decoration: InputDecoration(
                    labelText: 'Сортировка',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _sortOptions.map((sort) => DropdownMenuItem(
                    value: sort,
                    child: Text(sort, style: const TextStyle(fontSize: 14)),
                  )).toList(),
                  onChanged: (value) => setState(() => _selectedSort = value!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey.shade600,
        indicatorColor: Theme.of(context).primaryColor,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'Все специалисты'),
          Tab(text: 'Избранное'),
          Tab(text: 'Недавние'),
        ],
      ),
    );
  }

  Widget _buildAllSpecialistsTab() {
    final filteredSpecialists = _getFilteredSpecialists();
    
    if (filteredSpecialists.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Специалисты не найдены',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Попробуйте изменить параметры поиска',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredSpecialists.length,
      itemBuilder: (context, index) => _buildSpecialistCard(filteredSpecialists[index]),
    );
  }

  Widget _buildFavoritesTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Нет избранных специалистов',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Добавляйте понравившихся специалистов в избранное',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Нет недавних просмотров',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Здесь будут отображаться недавно просмотренные специалисты',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialistCard(Map<String, dynamic> specialist) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(specialist['avatar']),
                    ),
                    if (specialist['isOnline'])
                      Positioned(
                        bottom: 0,
                        right: 0,
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _toggleFavorite(specialist['id']),
                            icon: const Icon(
                              Icons.favorite_border,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        specialist['title'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(
                            '${specialist['rating']}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${specialist['reviewsCount']})',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 2),
                          Text(
                            specialist['location'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
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
            Text(
              specialist['description'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: (specialist['skills'] as List<String>).take(4).map((skill) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  skill,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.work_outline, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  '${specialist['completedProjects']} проектов',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  'Отвечает через ${specialist['responseTime']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'От ₽${specialist['hourlyRate']}/час',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => _viewPortfolio(specialist),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                      ),
                      child: const Text(
                        'Портфолио',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _contactSpecialist(specialist),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Связаться',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredSpecialists() {
    List<Map<String, dynamic>> filtered = List.from(_specialists);
    
    // Фильтр по категории
    if (_selectedCategory != 'Все') {
      filtered = filtered.where((specialist) => specialist['category'] == _selectedCategory).toList();
    }
    
    // Фильтр по поисковому запросу
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((specialist) {
        return specialist['name'].toLowerCase().contains(query) ||
               specialist['title'].toLowerCase().contains(query) ||
               specialist['description'].toLowerCase().contains(query) ||
               (specialist['skills'] as List<String>).any((skill) => skill.toLowerCase().contains(query));
      }).toList();
    }
    
    // Фильтр по цене
    filtered = filtered.where((specialist) {
      final price = specialist['hourlyRate'].toDouble();
      return price >= _minPrice && price <= _maxPrice;
    }).toList();
    
    // Сортировка
    switch (_selectedSort) {
      case 'Цена (по возрастанию)':
        filtered.sort((a, b) => a['hourlyRate'].compareTo(b['hourlyRate']));
        break;
      case 'Цена (по убыванию)':
        filtered.sort((a, b) => b['hourlyRate'].compareTo(a['hourlyRate']));
        break;
      case 'Количество отзывов':
        filtered.sort((a, b) => b['reviewsCount'].compareTo(a['reviewsCount']));
        break;
      case 'Время отклика':
        // Простая сортировка по времени отклика (в реальности нужна более сложная логика)
        filtered.sort((a, b) => a['responseTime'].compareTo(b['responseTime']));
        break;
      default: // Рейтинг
        filtered.sort((a, b) => b['rating'].compareTo(a['rating']));
    }
    
    return filtered;
  }

  void _showFiltersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Фильтры'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Цена за час: ₽${_minPrice.round()} - ₽${_maxPrice.round()}'),
            RangeSlider(
              values: RangeValues(_minPrice, _maxPrice),
              min: 0,
              max: 10000,
              divisions: 100,
              labels: RangeLabels(
                '₽${_minPrice.round()}',
                '₽${_maxPrice.round()}',
              ),
              onChanged: (values) => setState(() {
                _minPrice = values.start;
                _maxPrice = values.end;
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Применить'),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(String specialistId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Добавлено в избранное'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _viewPortfolio(Map<String, dynamic> specialist) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Портфолио ${specialist['name']}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: (specialist['portfolio'] as List<String>).map((imageUrl) => 
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ).toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Закрыть'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _contactSpecialist(Map<String, dynamic> specialist) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Связаться со специалистом'),
        content: Text('Начать диалог с ${specialist['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Диалог с ${specialist['name']} создан!'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Написать'),
          ),
        ],
      ),
    );
  }
}
