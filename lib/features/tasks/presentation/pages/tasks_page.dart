import 'package:flutter/material.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with TickerProviderStateMixin {
  String _selectedCategory = 'Все';
  String _selectedStatus = 'Все';
  String _searchQuery = '';
  late TabController _tabController;

  final List<String> _categories = [
    'Все', 'Красота', 'Ремонт', 'IT', 'Обучение', 'Фитнес', 'Уборка'
  ];

  final List<String> _statuses = [
    'Все', 'Новые', 'В работе', 'Завершенные'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
                  _buildTasksList('open'),
                  _buildTasksList('my'),
                  _buildTasksList('history'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateTaskDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Создать задачу'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
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
                  'Задачи',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Найдите идеальную задачу',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showFilterDialog(),
            icon: Icon(
              Icons.filter_list,
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
                hintText: 'Поиск задач...',
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Быстрые фильтры
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
          Tab(text: 'Открытые'),
          Tab(text: 'Мои задачи'),
          Tab(text: 'История'),
        ],
      ),
    );
  }

  Widget _buildTasksList(String type) {
    final tasks = _getFilteredTasks(type);
    
    if (tasks.isEmpty) {
      return _buildEmptyState(type);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskCard(task);
      },
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
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
          onTap: () => _showTaskDetails(task),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            task['description'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(task['status']).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        task['status'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getStatusColor(task['status']),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      task['location'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${task['price']} ₽',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task['category'],
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      task['time'],
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
        ),
      ),
    );
  }

  Widget _buildEmptyState(String type) {
    String title;
    String subtitle;
    IconData icon;

    switch (type) {
      case 'my':
        title = 'У вас нет активных задач';
        subtitle = 'Создайте новую задачу или откликнитесь на существующую';
        icon = Icons.assignment_outlined;
        break;
      case 'history':
        title = 'История пуста';
        subtitle = 'Здесь будут отображаться завершенные задачи';
        icon = Icons.history;
        break;
      default:
        title = 'Нет доступных задач';
        subtitle = 'Попробуйте изменить фильтры поиска';
        icon = Icons.search_off;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'новая':
        return Colors.green;
      case 'в работе':
        return Colors.orange;
      case 'завершена':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  List<Map<String, dynamic>> _getFilteredTasks(String type) {
    List<Map<String, dynamic>> allTasks = [
      {
        'id': 1,
        'title': 'Ремонт смесителя на кухне',
        'description': 'Требуется замена прокладки и настройка смесителя. Работа не сложная, нужен опытный сантехник.',
        'category': 'Ремонт',
        'price': 2500,
        'location': 'Москва, Центр',
        'status': 'Новая',
        'time': '2 часа назад',
        'client': 'Анна М.',
      },
      {
        'id': 2,
        'title': 'Создание сайта-визитки',
        'description': 'Нужен простой сайт для строительной компании. 5-6 страниц, адаптивный дизайн.',
        'category': 'IT',
        'price': 25000,
        'location': 'Удаленно',
        'status': 'Новая',
        'time': '1 час назад',
        'client': 'ООО "Стройка"',
      },
      {
        'id': 3,
        'title': 'Стрижка и укладка',
        'description': 'Нужен парикмахер на дом для стрижки и укладки волос к важному мероприятию.',
        'category': 'Красота',
        'price': 3000,
        'location': 'Москва, Юг',
        'status': 'В работе',
        'time': '3 часа назад',
        'client': 'Елена К.',
      },
      {
        'id': 4,
        'title': 'Генеральная уборка квартиры',
        'description': 'Требуется качественная уборка 2-комнатной квартиры после ремонта.',
        'category': 'Уборка',
        'price': 4500,
        'location': 'Москва, Север',
        'status': 'Новая',
        'time': '30 минут назад',
        'client': 'Дмитрий П.',
      },
      {
        'id': 5,
        'title': 'Персональная тренировка',
        'description': 'Ищу тренера для занятий в домашних условиях. Цель - похудение и общее укрепление.',
        'category': 'Фитнес',
        'price': 2000,
        'location': 'Москва, Запад',
        'status': 'Завершена',
        'time': '1 день назад',
        'client': 'Мария С.',
      },
    ];

    // Фильтрация по типу
    List<Map<String, dynamic>> filteredTasks = [];
    switch (type) {
      case 'open':
        filteredTasks = allTasks.where((task) => 
          task['status'] == 'Новая').toList();
        break;
      case 'my':
        filteredTasks = allTasks.where((task) => 
          task['status'] == 'В работе').toList();
        break;
      case 'history':
        filteredTasks = allTasks.where((task) => 
          task['status'] == 'Завершена').toList();
        break;
    }

    // Фильтрация по категории
    if (_selectedCategory != 'Все') {
      filteredTasks = filteredTasks.where((task) => 
        task['category'] == _selectedCategory).toList();
    }

    // Фильтрация по поисковому запросу
    if (_searchQuery.isNotEmpty) {
      filteredTasks = filteredTasks.where((task) =>
        task['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
        task['description'].toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    return filteredTasks;
  }

  void _showTaskDetails(Map<String, dynamic> task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
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
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            task['title'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusColor(task['status']).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            task['status'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _getStatusColor(task['status']),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      task['description'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.person_outline, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Text('Клиент: ${task['client']}'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Text(task['location']),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Text('Опубликовано ${task['time']}'),
                      ],
                    ),
                    const SizedBox(height: 20),
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
                            'Бюджет',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${task['price']} ₽',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (task['status'] == 'Новая')
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _respondToTask(task);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Откликнуться на задачу',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
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

  void _showCreateTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Создать задачу'),
        content: const Text('Функция создания задачи будет доступна в следующих версиях приложения.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Понятно'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Фильтры'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Статус задачи:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _statuses.map((status) {
                return FilterChip(
                  label: Text(status),
                  selected: _selectedStatus == status,
                  onSelected: (selected) {
                    setState(() {
                      _selectedStatus = status;
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Применить'),
          ),
        ],
      ),
    );
  }

  void _respondToTask(Map<String, dynamic> task) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Отклик на задачу "${task['title']}" отправлен!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
