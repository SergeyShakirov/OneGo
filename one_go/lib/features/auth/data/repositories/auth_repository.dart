import 'package:dio/dio.dart';
// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:injectable/injectable.dart';

import '../../../../shared/models/user_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required UserRole role,
  });

  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, void>> resetPassword(String email);

  Stream<User?> get authStateChanges;
}

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required UserRole role,
  }) async {
    try {
      // Mock delay to simulate network call
      await Future.delayed(const Duration(seconds: 1));
      
      // Create mock user
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        role: role,
        rating: 0.0,
        reviewCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      return Right(user);
    } catch (e) {
      return Left(AuthFailure('Ошибка регистрации: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Mock delay to simulate network call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock validation
      if (email.isEmpty || password.isEmpty) {
        return Left(AuthFailure('Email и пароль не могут быть пустыми'));
      }
      
      if (password.length < 6) {
        return Left(AuthFailure('Неверный пароль'));
      }

      // Create mock user
      final user = User(
        id: 'mock_user_id',
        email: email,
        firstName: 'Mock',
        lastName: 'User',
        phone: '+1234567890',
        role: UserRole.customer,
        rating: 4.5,
        reviewCount: 10,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      return Right(user);
    } catch (e) {
      return Left(AuthFailure('Ошибка входа: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      // Mock delay
      await Future.delayed(const Duration(milliseconds: 500));
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure('Ошибка выхода: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // For demo, return null (no current user)
      return Left(AuthFailure('Пользователь не авторизован'));
    } catch (e) {
      return Left(AuthFailure('Ошибка получения пользователя: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      // Mock delay
      await Future.delayed(const Duration(seconds: 1));
      
      if (email.isEmpty) {
        return Left(AuthFailure('Email не может быть пустым'));
      }
      
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure('Ошибка сброса пароля: $e'));
    }
  }

  @override
  Stream<User?> get authStateChanges {
    // Mock stream - always returns null (no authenticated user)
    return Stream.value(null);
  }
}
