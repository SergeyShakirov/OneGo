import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {
  final String? category;
  final String? sortBy;

  const LoadTasks({this.category, this.sortBy});

  @override
  List<Object?> get props => [category, sortBy];
}

class CreateTask extends TaskEvent {
  final CreateTaskRequest request;

  const CreateTask(this.request);

  @override
  List<Object> get props => [request];
}

class LoadMyTasks extends TaskEvent {
  final String userId;

  const LoadMyTasks(this.userId);

  @override
  List<Object> get props => [userId];
}

class RespondToTask extends TaskEvent {
  final String taskId;
  final String? message;

  const RespondToTask(this.taskId, {this.message});

  @override
  List<Object?> get props => [taskId, message];
}

class RefreshTasks extends TaskEvent {}

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final String? currentCategory;
  final String? currentSort;

  const TaskLoaded({
    required this.tasks,
    this.currentCategory,
    this.currentSort,
  });

  @override
  List<Object?> get props => [tasks, currentCategory, currentSort];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}

class TaskCreated extends TaskState {
  final Task task;

  const TaskCreated(this.task);

  @override
  List<Object> get props => [task];
}

class TaskOperationSuccess extends TaskState {
  final String message;

  const TaskOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}
