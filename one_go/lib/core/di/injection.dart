import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../config/api_config.dart';
import '../../features/tasks/data/datasources/task_api_service.dart';
import '../../features/tasks/data/repositories/task_repository_impl.dart';
import '../../features/tasks/domain/repositories/task_repository.dart';
import '../../features/tasks/presentation/bloc/task_bloc.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

@module
abstract class RegisterModule {
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  Dio get dio {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
    ));
    
    // Добавляем интерцептор для логирования
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('DIO: $obj'),
    ));
    
    return dio;
  }

  @lazySingleton
  TaskApiService taskApiService(Dio dio) => TaskApiService(dio);

  @lazySingleton
  TaskRepository taskRepository(TaskApiService apiService) => TaskRepositoryImpl(apiService);

  @lazySingleton
  TaskBloc taskBloc(TaskRepository repository) => TaskBloc(repository);
}
