import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/helpers.dart';

class ChatPage extends StatefulWidget {
  final String chatId;

  const ChatPage({super.key, required this.chatId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<Map<String, dynamic>> _messages = [];
  Map<String, dynamic>? _chat;
  bool _isLoading = true;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadChat();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final participant = _chat!['participant'] as Map<String, dynamic>;
    final service = _chat!['service'] as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text(
                '${participant['firstName'][0]}${participant['lastName'][0]}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${participant['firstName']} ${participant['lastName']}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    service['title'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Show chat options
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _MessageBubble(
                  message: message,
                  isFromCurrentUser: message['isFromCurrentUser'],
                );
              },
            ),
          ),
          
          // Message Input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              // TODO: Attach file or image
            },
            icon: const Icon(Icons.attach_file),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Введите сообщение...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _isSending ? null : _sendMessage,
              icon: _isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadChat() async {
    try {
      // Mock data - replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final mockChat = {
        'id': widget.chatId,
        'participant': {
          'id': 'user_1',
          'firstName': 'Анна',
          'lastName': 'Иванова',
          'avatar': null,
        },
        'service': {
          'id': 'service_1',
          'title': 'Уборка квартиры',
        },
      };

      final mockMessages = [
        {
          'id': 'msg_1',
          'text': 'Добрый день! Интересует ваша услуга по уборке квартиры.',
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
          'isFromCurrentUser': true,
        },
        {
          'id': 'msg_2',
          'text': 'Здравствуйте! Конечно, с удовольствием помогу с уборкой. Какая площадь квартиры?',
          'timestamp': DateTime.now().subtract(const Duration(hours: 2, minutes: -5)),
          'isFromCurrentUser': false,
        },
        {
          'id': 'msg_3',
          'text': '2-комнатная квартира, примерно 60 кв.м.',
          'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
          'isFromCurrentUser': true,
        },
        {
          'id': 'msg_4',
          'text': 'Отлично! Для такой площади потребуется примерно 3-4 часа. Когда вам удобно?',
          'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
          'isFromCurrentUser': false,
        },
        {
          'id': 'msg_5',
          'text': 'Завтра после обеда подойдет?',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
          'isFromCurrentUser': true,
        },
        {
          'id': 'msg_6',
          'text': 'Да, отлично! Во сколько именно?',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 25)),
          'isFromCurrentUser': false,
        },
      ];

      if (mounted) {
        setState(() {
          _chat = mockChat;
          _messages = mockMessages;
          _isLoading = false;
        });
        _scrollToBottom();
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

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isSending = true;
    });

    try {
      // Add message to list immediately
      final newMessage = {
        'id': 'msg_${DateTime.now().millisecondsSinceEpoch}',
        'text': text,
        'timestamp': DateTime.now(),
        'isFromCurrentUser': true,
      };

      setState(() {
        _messages.add(newMessage);
        _messageController.clear();
      });

      _scrollToBottom();

      // TODO: Send message to API
      await Future.delayed(const Duration(milliseconds: 500));

      // Simulate response (in real app, this would come from WebSocket or push notification)
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted && text.toLowerCase().contains('во сколько')) {
        final responseMessage = {
          'id': 'msg_${DateTime.now().millisecondsSinceEpoch}',
          'text': 'Подойдет 14:00?',
          'timestamp': DateTime.now(),
          'isFromCurrentUser': false,
        };

        setState(() {
          _messages.add(responseMessage);
        });

        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка отправки: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

class _MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isFromCurrentUser;

  const _MessageBubble({
    required this.message,
    required this.isFromCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isFromCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isFromCurrentUser) ...[
            CircleAvatar(
              radius: 12,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Text(
                'А',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isFromCurrentUser
                    ? AppColors.primary
                    : Colors.white,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: isFromCurrentUser
                      ? const Radius.circular(16)
                      : const Radius.circular(4),
                  bottomRight: isFromCurrentUser
                      ? const Radius.circular(4)
                      : const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message['text'],
                    style: TextStyle(
                      fontSize: 14,
                      color: isFromCurrentUser
                          ? Colors.white
                          : AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateHelper.formatTime(message['timestamp']),
                    style: TextStyle(
                      fontSize: 10,
                      color: isFromCurrentUser
                          ? Colors.white.withValues(alpha: 0.7)
                          : AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isFromCurrentUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 12,
              backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
              child: const Text(
                'Я',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
