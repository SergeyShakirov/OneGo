import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../shared/widgets/common_widgets.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<Map<String, dynamic>> _chats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Сообщения'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Search chats
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _chats.isEmpty
              ? const EmptyState(
                  title: 'Нет сообщений',
                  description: 'Начните общение с исполнителями услуг',
                  icon: Icons.chat_bubble_outline,
                )
              : RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _chats.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final chat = _chats[index];
                      return _ChatTile(
                        chat: chat,
                        onTap: () {
                          context.push('/chat/${chat['id']}');
                        },
                      );
                    },
                  ),
                ),
    );
  }

  Future<void> _loadChats() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Mock data - replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final mockChats = [
        {
          'id': 'chat_1',
          'participant': {
            'id': 'user_1',
            'firstName': 'Анна',
            'lastName': 'Иванова',
            'avatar': null,
          },
          'lastMessage': {
            'text': 'Добрый день! Когда вам удобно выполнить уборку?',
            'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
            'isFromCurrentUser': false,
          },
          'unreadCount': 2,
          'service': {
            'id': 'service_1',
            'title': 'Уборка квартиры',
          },
        },
        {
          'id': 'chat_2',
          'participant': {
            'id': 'user_2',
            'firstName': 'Сергей',
            'lastName': 'Петров',
            'avatar': null,
          },
          'lastMessage': {
            'text': 'Спасибо за отличную работу!',
            'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
            'isFromCurrentUser': true,
          },
          'unreadCount': 0,
          'service': {
            'id': 'service_2',
            'title': 'Ремонт техники',
          },
        },
        {
          'id': 'chat_3',
          'participant': {
            'id': 'user_3',
            'firstName': 'Мария',
            'lastName': 'Смирнова',
            'avatar': null,
          },
          'lastMessage': {
            'text': 'Можем встретиться завтра в 14:00?',
            'timestamp': DateTime.now().subtract(const Duration(days: 1)),
            'isFromCurrentUser': false,
          },
          'unreadCount': 1,
          'service': {
            'id': 'service_3',
            'title': 'Репетиторство по математике',
          },
        },
      ];

      if (mounted) {
        setState(() {
          _chats = mockChats;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки: $e')),
        );
      }
    }
  }

  Future<void> _onRefresh() async {
    await _loadChats();
  }
}

class _ChatTile extends StatelessWidget {
  final Map<String, dynamic> chat;
  final VoidCallback onTap;

  const _ChatTile({
    required this.chat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final participant = chat['participant'] as Map<String, dynamic>;
    final lastMessage = chat['lastMessage'] as Map<String, dynamic>;
    final service = chat['service'] as Map<String, dynamic>;
    final unreadCount = chat['unreadCount'] as int;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    '${participant['firstName'][0]}${participant['lastName'][0]}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                if (unreadCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        unreadCount > 99 ? '99+' : unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(width: 12),
            
            // Chat Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${participant['firstName']} ${participant['lastName']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        DateHelper.timeAgo(lastMessage['timestamp']),
                        style: TextStyle(
                          fontSize: 12,
                          color: unreadCount > 0 ? AppColors.primary : AppColors.textHint,
                          fontWeight: unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Service
                  Text(
                    service['title'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Last Message
                  Row(
                    children: [
                      if (lastMessage['isFromCurrentUser'])
                        const Icon(
                          Icons.done_all,
                          size: 14,
                          color: AppColors.primary,
                        ),
                      if (lastMessage['isFromCurrentUser'])
                        const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          lastMessage['text'],
                          style: TextStyle(
                            fontSize: 14,
                            color: unreadCount > 0 ? AppColors.textPrimary : AppColors.textSecondary,
                            fontWeight: unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
