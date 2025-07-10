import 'package:go_router/go_router.dart';

// Import features
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/services/presentation/pages/service_list_page.dart';
import '../../features/services/presentation/pages/service_detail_page.dart';
import '../../features/booking/presentation/pages/booking_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/chat/presentation/pages/chat_list_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';

// Import shared widgets
import '../../shared/widgets/main_navigation.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      
      // Main App with Bottom Navigation
      ShellRoute(
        builder: (context, state, child) => MainNavigation(child: child),
        routes: [
          // Home
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          
          // Services
          GoRoute(
            path: '/services',
            name: 'services',
            builder: (context, state) => const ServiceListPage(),
            routes: [
              GoRoute(
                path: '/detail/:serviceId',
                name: 'service-detail',
                builder: (context, state) {
                  final serviceId = state.pathParameters['serviceId']!;
                  return ServiceDetailPage(serviceId: serviceId);
                },
              ),
            ],
          ),
          
          // Booking
          GoRoute(
            path: '/booking',
            name: 'booking',
            builder: (context, state) {
              final serviceId = state.uri.queryParameters['serviceId'];
              return BookingPage(serviceId: serviceId);
            },
          ),
          
          // Chat
          GoRoute(
            path: '/chat',
            name: 'chat-list',
            builder: (context, state) => const ChatListPage(),
            routes: [
              GoRoute(
                path: '/:chatId',
                name: 'chat',
                builder: (context, state) {
                  final chatId = state.pathParameters['chatId']!;
                  return ChatPage(chatId: chatId);
                },
              ),
            ],
          ),
          
          // Profile
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
}
