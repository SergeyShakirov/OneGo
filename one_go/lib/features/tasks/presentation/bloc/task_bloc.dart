import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/task_repository.dart';
import 'task_event_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _taskRepository;

  TaskBloc(this._taskRepository) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<CreateTask>(_onCreateTask);
    on<LoadMyTasks>(_onLoadMyTasks);
    on<RespondToTask>(_onRespondToTask);
    on<RefreshTasks>(_onRefreshTasks);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await _taskRepository.getTasks(
        category: event.category,
        sortBy: event.sortBy,
      );
      emit(TaskLoaded(
        tasks: tasks,
        currentCategory: event.category,
        currentSort: event.sortBy,
      ));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onCreateTask(CreateTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final task = await _taskRepository.createTask(event.request);
      emit(TaskCreated(task));
      
      // Reload tasks after creation
      final currentState = state;
      if (currentState is TaskLoaded) {
        final tasks = await _taskRepository.getTasks(
          category: currentState.currentCategory,
          sortBy: currentState.currentSort,
        );
        emit(TaskLoaded(
          tasks: tasks,
          currentCategory: currentState.currentCategory,
          currentSort: currentState.currentSort,
        ));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onLoadMyTasks(LoadMyTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await _taskRepository.getMyTasks(event.userId);
      emit(TaskLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onRespondToTask(RespondToTask event, Emitter<TaskState> emit) async {
    try {
      await _taskRepository.respondToTask(event.taskId, event.message ?? '');
      emit(const TaskOperationSuccess('Отклик отправлен успешно!'));
      
      // Reload tasks after response
      final currentState = state;
      if (currentState is TaskLoaded) {
        final tasks = await _taskRepository.getTasks(
          category: currentState.currentCategory,
          sortBy: currentState.currentSort,
        );
        emit(TaskLoaded(
          tasks: tasks,
          currentCategory: currentState.currentCategory,
          currentSort: currentState.currentSort,
        ));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onRefreshTasks(RefreshTasks event, Emitter<TaskState> emit) async {
    final currentState = state;
    if (currentState is TaskLoaded) {
      try {
        final tasks = await _taskRepository.getTasks(
          category: currentState.currentCategory,
          sortBy: currentState.currentSort,
        );
        emit(TaskLoaded(
          tasks: tasks,
          currentCategory: currentState.currentCategory,
          currentSort: currentState.currentSort,
        ));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    }
  }
}
