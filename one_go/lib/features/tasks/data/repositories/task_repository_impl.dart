import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_api_service.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskApiService _apiService;

  TaskRepositoryImpl(this._apiService);

  @override
  Future<List<Task>> getTasks({
    String? category,
    String? sortBy,
    int? limit,
    int? offset,
  }) async {
    return await _apiService.getTasks(
      category: category,
      sortBy: sortBy,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<Task> getTaskById(String id) async {
    return await _apiService.getTaskById(id);
  }

  @override
  Future<Task> createTask(CreateTaskRequest request) async {
    return await _apiService.createTask(request);
  }

  @override
  Future<Task> updateTask(String id, Map<String, dynamic> updates) async {
    return await _apiService.updateTask(id, updates);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _apiService.deleteTask(id);
  }

  @override
  Future<List<Task>> getMyTasks(String userId) async {
    return await _apiService.getMyTasks(userId);
  }

  @override
  Future<void> respondToTask(String taskId, String message) async {
    await _apiService.respondToTask(taskId, message);
  }
}
