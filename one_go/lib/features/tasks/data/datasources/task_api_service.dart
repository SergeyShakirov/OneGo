import 'package:dio/dio.dart';
import '../../domain/entities/task.dart';

class TaskApiService {
  final Dio _dio;
  static const String _basePath = '/api/tasks';

  TaskApiService(this._dio);

  Future<List<Task>> getTasks({
    String? category,
    String? sortBy,
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await _dio.get(
        _basePath,
        queryParameters: {
          if (category != null && category != 'Все') 'category': category,
          if (sortBy != null) 'sort_by': sortBy,
          if (limit != null) 'limit': limit,
          if (offset != null) 'offset': offset,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> tasksJson = response.data['data'];
        return tasksJson.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Task> getTaskById(String id) async {
    try {
      final response = await _dio.get('$_basePath/$id');

      if (response.statusCode == 200) {
        return Task.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load task: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Task not found');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Task> createTask(CreateTaskRequest request) async {
    try {
      final response = await _dio.post(
        _basePath,
        data: request.toJson(),
      );

      if (response.statusCode == 201) {
        return Task.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to create task: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final errors = e.response?.data['errors'] ?? {};
        throw Exception('Validation error: ${errors.toString()}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Task> updateTask(String id, Map<String, dynamic> updates) async {
    try {
      final response = await _dio.put(
        '$_basePath/$id',
        data: updates,
      );

      if (response.statusCode == 200) {
        return Task.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Task not found');
      }
      if (e.response?.statusCode == 403) {
        throw Exception('Access denied');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final response = await _dio.delete('$_basePath/$id');

      if (response.statusCode != 204) {
        throw Exception('Failed to delete task: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Task not found');
      }
      if (e.response?.statusCode == 403) {
        throw Exception('Access denied');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<Task>> getMyTasks(String userId) async {
    try {
      final response = await _dio.get(
        '$_basePath/my',
        queryParameters: {'user_id': userId},
      );

      if (response.statusCode == 200) {
        final List<dynamic> tasksJson = response.data['data'];
        return tasksJson.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load my tasks: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> respondToTask(String taskId, String message) async {
    try {
      final response = await _dio.post(
        '$_basePath/$taskId/responses',
        data: {'message': message},
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to respond to task: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Task not found');
      }
      if (e.response?.statusCode == 409) {
        throw Exception('You have already responded to this task');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
