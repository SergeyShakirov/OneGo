import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),
              
              _buildStatsSection(),
              const SizedBox(height: 24),
              
              _buildMenuSection(),
              const SizedBox(height: 24),
              
              _buildSettingsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: _user!['avatar'] != null
                ? ClipOval(
                    child: Image.network(
                      _user!['avatar'],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                : Text(
                    '${_user!['firstName'][0]}${_user!['lastName'][0]}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          Text(
            '${_user!['firstName']} ${_user!['lastName']}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _user!['email'],
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          if (_user!['phone'] != null) ...[
            const SizedBox(height: 2),
            Text(
              _user!['phone'],
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _getRoleText(_user!['role']),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Статистика',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Рейтинг',
                  value: _user!['rating'].toStringAsFixed(1),
                  icon: Icons.star,
                  color: AppColors.ratingFilled,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Заказов',
                  value: '12',
                  icon: Icons.assignment,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Отзывов',
                  value: '${_user!['reviewCount']}',
                  icon: Icons.rate_review,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Container(
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
      child: Column(
        children: [
          _MenuTile(
            icon: Icons.history,
            title: 'История заказов',
            subtitle: 'Просмотр всех ваших заказов',
            onTap: () {
              // TODO: Navigate to order history
            },
          ),
          const Divider(height: 1),
          _MenuTile(
            icon: Icons.favorite,
            title: 'Избранное',
            subtitle: 'Сохраненные услуги',
            onTap: () {
              // TODO: Navigate to favorites
            },
          ),
          const Divider(height: 1),
          _MenuTile(
            icon: Icons.notifications,
            title: 'Уведомления',
            subtitle: 'Настройка уведомлений',
            onTap: () {
              // TODO: Navigate to notifications
            },
          ),
          const Divider(height: 1),
          _MenuTile(
            icon: Icons.payment,
            title: 'Способы оплаты',
            subtitle: 'Управление картами и кошельками',
            onTap: () {
              // TODO: Navigate to payment methods
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
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
      child: Column(
        children: [
          _MenuTile(
            icon: Icons.edit,
            title: 'Редактировать профиль',
            subtitle: 'Изменить личную информацию',
            onTap: () {
              // TODO: Navigate to edit profile
            },
          ),
          const Divider(height: 1),
          _MenuTile(
            icon: Icons.security,
            title: 'Безопасность',
            subtitle: 'Пароль и двухфакторная аутентификация',
            onTap: () {
              // TODO: Navigate to security settings
            },
          ),
          const Divider(height: 1),
          _MenuTile(
            icon: Icons.help,
            title: 'Помощь и поддержка',
            subtitle: 'FAQ и связь с поддержкой',
            onTap: () {
              // TODO: Navigate to help
            },
          ),
          const Divider(height: 1),
          _MenuTile(
            icon: Icons.info,
            title: 'О приложении',
            subtitle: 'Версия, лицензии и условия',
            onTap: () {
              _showAboutDialog();
            },
          ),
          const Divider(height: 1),
          _MenuTile(
            icon: Icons.logout,
            title: 'Выйти',
            subtitle: 'Выход из аккаунта',
            iconColor: AppColors.error,
            titleColor: AppColors.error,
            onTap: () {
              _showLogoutDialog();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _loadUserProfile() async {
    try {
      // Mock data - replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final mockUser = {
        'id': 'user_1',
        'firstName': 'Иван',
        'lastName': 'Петров',
        'email': 'ivan.petrov@example.com',
        'phone': '+7 (999) 123-45-67',
        'avatar': null,
        'role': 'customer',
        'rating': 4.8,
        'reviewCount': 15,
        'createdAt': DateTime.now().subtract(const Duration(days: 90)),
      };

      if (mounted) {
        setState(() {
          _user = mockUser;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки профиля: $e')),
        );
      }
    }
  }

  Future<void> _onRefresh() async {
    await _loadUserProfile();
  }

  String _getRoleText(String role) {
    switch (role) {
      case 'customer':
        return 'Клиент';
      case 'provider':
        return 'Исполнитель';
      case 'both':
        return 'Клиент и Исполнитель';
      default:
        return 'Пользователь';
    }
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'OneGo',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.handyman,
        size: 48,
        color: AppColors.primary,
      ),
      children: [
        const Text('Кроссплатформенное мобильное приложение для оказания разовых услуг.'),
        const SizedBox(height: 16),
        const Text('© 2025 OneGo. Все права защищены.'),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выход из аккаунта'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: titleColor ?? AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textHint,
      ),
      onTap: onTap,
    );
  }
}
