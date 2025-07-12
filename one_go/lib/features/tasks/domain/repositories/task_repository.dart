import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks({
    String? category,
    String? sortBy,
    int? limit,
    int? offset,
  });
  
  Future<Task> getTaskById(String id);
  
  Future<Task> createTask(CreateTaskRequest request);
  
  Future<Task> updateTask(String id, Map<String, dynamic> updates);
  
  Future<void> deleteTask(String id);
  
  Future<List<Task>> getMyTasks(String userId);
  
  Future<void> respondToTask(String taskId, String message);
}
