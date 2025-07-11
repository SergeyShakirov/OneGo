import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> with TickerProviderStateMixin {
  String _searchQuery = '';
  String _selectedFilter = 'all'; // all, active, archived
  late TabController _tabController;

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
                  _buildChatsList('all'),
                  _buildChatsList('active'),
                  _buildChatsList('archived'),
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
                  'Чаты',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Активных диалогов: ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '${_getActiveChatsCount()}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showChatSettings(),
            icon: Icon(
              Icons.more_vert,
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
      child: Container(
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
            hintText: 'Поиск чатов...',
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    onPressed: () => setState(() => _searchQuery = ''),
                    icon: Icon(Icons.clear, color: Colors.grey.shade500),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
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
        tabs: [
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Все'),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${_getFilteredChats('all').length}',
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Активные'),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${_getFilteredChats('active').length}',
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Архив'),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${_getFilteredChats('archived').length}',
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatsList(String type) {
    final chats = _getFilteredChats(type);
    
    if (chats.isEmpty) {
      return _buildEmptyState(type);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return _buildChatCard(chat);
      },
    );
  }

  Widget _buildChatCard(Map<String, dynamic> chat) {
    final hasUnread = chat['unreadCount'] > 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: hasUnread 
            ? Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.3), width: 1.5)
            : null,
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
          onTap: () => _openChat(chat),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Аватар с индикатором онлайн статуса
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(chat['avatar']),
                    ),
                    if (chat['isOnline'])
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
                    if (chat['type'] == 'group')
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.group,
                            size: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                // Информация о чате
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            chat['lastMessageTime'],
                            style: TextStyle(
                              fontSize: 12,
                              color: hasUnread 
                                  ? Theme.of(context).primaryColor 
                                  : Colors.grey.shade600,
                              fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (chat['lastMessageSender'] == 'me')
                            Icon(
                              chat['lastMessageStatus'] == 'read' 
                                  ? Icons.done_all 
                                  : Icons.done,
                              size: 16,
                              color: chat['lastMessageStatus'] == 'read' 
                                  ? Theme.of(context).primaryColor 
                                  : Colors.grey.shade500,
                            ),
                          if (chat['lastMessageSender'] == 'me')
                            const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              chat['lastMessage'],
                              style: TextStyle(
                                fontSize: 14,
                                color: hasUnread ? Colors.black87 : Colors.grey.shade600,
                                fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (hasUnread)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(minWidth: 18),
                              child: Text(
                                chat['unreadCount'] > 99 ? '99+' : '${chat['unreadCount']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Статус чата и теги
                      Row(
                        children: [
                          if (chat['isPinned'])
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.push_pin,
                                size: 12,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          if (chat['status'] != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getStatusColor(chat['status']).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                chat['status'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _getStatusColor(chat['status']),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          const Spacer(),
                          if (chat['isMuted'])
                            Icon(
                              Icons.volume_off,
                              size: 12,
                              color: Colors.grey.shade500,
                            ),
                        ],
                      ),
                    ],
                  ),
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
      case 'active':
        title = 'Нет активных чатов';
        subtitle = 'Начните общение со специалистами';
        icon = Icons.chat_bubble_outline;
        break;
      case 'archived':
        title = 'Архив пуст';
        subtitle = 'Архивированные чаты будут здесь';
        icon = Icons.archive_outlined;
        break;
      default:
        title = 'Нет чатов';
        subtitle = 'Ваши диалоги появятся здесь';
        icon = Icons.chat_outlined;
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
      case 'новый заказ':
        return Colors.green;
      case 'в работе':
        return Colors.orange;
      case 'завершен':
        return Colors.blue;
      case 'отменен':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  int _getActiveChatsCount() {
    return _getFilteredChats('active').length;
  }

  List<Map<String, dynamic>> _getFilteredChats(String type) {
    List<Map<String, dynamic>> allChats = [
      {
        'id': 1,
        'name': 'Анна Петрова',
        'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b612b865?w=200&h=200&fit=crop&crop=face',
        'lastMessage': 'Добрый день! Готова приехать к вам завтра в 15:00',
        'lastMessageTime': '14:30',
        'lastMessageSender': 'other',
        'lastMessageStatus': 'delivered',
        'unreadCount': 2,
        'isOnline': true,
        'isPinned': true,
        'isMuted': false,
        'type': 'private',
        'status': 'Новый заказ',
        'isActive': true,
        'isArchived': false,
      },
      {
        'id': 2,
        'name': 'Дмитрий Козлов',
        'avatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&crop=face',
        'lastMessage': 'Работа выполнена. Спасибо за заказ!',
        'lastMessageTime': 'вчера',
        'lastMessageSender': 'other',
        'lastMessageStatus': 'read',
        'unreadCount': 0,
        'isOnline': false,
        'isPinned': false,
        'isMuted': false,
        'type': 'private',
        'status': 'Завершен',
        'isActive': false,
        'isArchived': false,
      },
      {
        'id': 3,
        'name': 'Елена Волкова',
        'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&h=200&fit=crop&crop=face',
        'lastMessage': 'Вы: Когда сможете начать работу над сайтом?',
        'lastMessageTime': '12:45',
        'lastMessageSender': 'me',
        'lastMessageStatus': 'read',
        'unreadCount': 0,
        'isOnline': true,
        'isPinned': false,
        'isMuted': false,
        'type': 'private',
        'status': 'В работе',
        'isActive': true,
        'isArchived': false,
      },
      {
        'id': 4,
        'name': 'Михаил Соколов',
        'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop&crop=face',
        'lastMessage': 'Отличная тренировка! До встречи в пятницу',
        'lastMessageTime': '2 дня',
        'lastMessageSender': 'other',
        'lastMessageStatus': 'read',
        'unreadCount': 0,
        'isOnline': false,
        'isPinned': false,
        'isMuted': false,
        'type': 'private',
        'status': 'В работе',
        'isActive': true,
        'isArchived': false,
      },
      {
        'id': 5,
        'name': 'Ольга Иванова',
        'avatar': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=200&fit=crop&crop=face',
        'lastMessage': 'Уборка завершена. Все чисто!',
        'lastMessageTime': '5 дней',
        'lastMessageSender': 'other',
        'lastMessageStatus': 'read',
        'unreadCount': 0,
        'isOnline': false,
        'isPinned': false,
        'isMuted': true,
        'type': 'private',
        'status': 'Завершен',
        'isActive': false,
        'isArchived': true,
      },
      {
        'id': 6,
        'name': 'Группа: Ремонт квартиры',
        'avatar': 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=200&h=200&fit=crop',
        'lastMessage': 'Иван: Завтра начинаем работы по кухне',
        'lastMessageTime': '16:20',
        'lastMessageSender': 'other',
        'lastMessageStatus': 'delivered',
        'unreadCount': 5,
        'isOnline': false,
        'isPinned': true,
        'isMuted': false,
        'type': 'group',
        'status': 'В работе',
        'isActive': true,
        'isArchived': false,
      },
    ];

    List<Map<String, dynamic>> filteredChats = [];
    
    switch (type) {
      case 'active':
        filteredChats = allChats.where((chat) => 
          chat['isActive'] == true && chat['isArchived'] == false).toList();
        break;
      case 'archived':
        filteredChats = allChats.where((chat) => 
          chat['isArchived'] == true).toList();
        break;
      default:
        filteredChats = allChats.where((chat) => 
          chat['isArchived'] == false).toList();
    }

    // Фильтрация по поисковому запросу
    if (_searchQuery.isNotEmpty) {
      filteredChats = filteredChats.where((chat) =>
        chat['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
        chat['lastMessage'].toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    // Сортировка: сначала закрепленные, потом по времени последнего сообщения
    filteredChats.sort((a, b) {
      if (a['isPinned'] && !b['isPinned']) return -1;
      if (!a['isPinned'] && b['isPinned']) return 1;
      
      // Простая сортировка по времени (в реальном приложении была бы по timestamp)
      final timeA = a['lastMessageTime'];
      final timeB = b['lastMessageTime'];
      
      if (timeA.contains(':') && !timeB.contains(':')) return -1;
      if (!timeA.contains(':') && timeB.contains(':')) return 1;
      
      return 0;
    });

    return filteredChats;
  }

  void _openChat(Map<String, dynamic> chat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailPage(chat: chat),
      ),
    );
  }

  void _showChatSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            ListTile(
              leading: const Icon(Icons.mark_chat_read),
              title: const Text('Отметить все как прочитанные'),
              onTap: () {
                Navigator.pop(context);
                _markAllAsRead();
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text('Архивировать прочитанные'),
              onTap: () {
                Navigator.pop(context);
                _archiveReadChats();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Настройки чатов'),
              onTap: () {
                Navigator.pop(context);
                _openChatSettings();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _markAllAsRead() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Все чаты отмечены как прочитанные'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
    setState(() {
      // В реальном приложении здесь было бы обновление состояния
    });
  }

  void _archiveReadChats() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Прочитанные чаты перенесены в архив'),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openChatSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Настройки чатов будут доступны в следующих версиях'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// Простая страница детального чата для демонстрации
class ChatDetailPage extends StatelessWidget {
  final Map<String, dynamic> chat;

  const ChatDetailPage({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(chat['avatar']),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat['name'],
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (chat['isOnline'])
                    const Text(
                      'онлайн',
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Детальный чат будет реализован\nв следующих версиях',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
