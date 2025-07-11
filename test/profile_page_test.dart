import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_go/features/profile/presentation/pages/profile_page.dart';

void main() {
  group('ProfilePage Widget Tests', () {
    testWidgets('renders user name and avatar', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
      expect(find.text('Александр Иванов'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('renders balance and statistics', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
      expect(find.textContaining('₽'), findsWidgets);
      expect(find.text('Статистика'), findsOneWidget);
      expect(find.text('Баланс кошелька'), findsOneWidget);
    });

    testWidgets('renders quick actions and menu items', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
      expect(find.text('Быстрые действия'), findsOneWidget);
      expect(find.text('Создать задачу'), findsOneWidget);
      expect(find.text('Выйти'), findsOneWidget);
    });
  });
}
