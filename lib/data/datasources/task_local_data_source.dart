import '../../models/task_model.dart';
import '../../services/hive_service.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getAllTasks();
  Future<TaskModel?> getTask(int id);
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(int id);
  Future<List<TaskModel>> getTasksBySubject(int subjectId);
}

class HiveTaskLocalDataSource implements TaskLocalDataSource {
  HiveTaskLocalDataSource();

  @override
  Future<void> addTask(TaskModel task) async {
    await HiveService.instance.addTask(task);
  }

  @override
  Future<void> deleteTask(int id) async {
    await HiveService.instance.deleteTask(id);
  }

  @override
  Future<TaskModel?> getTask(int id) async {
    final tasks = HiveService.instance.getTasks();
    try {
      return tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<TaskModel>> getAllTasks() async {
    return HiveService.instance.getTasks();
  }

  @override
  Future<List<TaskModel>> getTasksBySubject(int subjectId) async {
    final tasks = HiveService.instance.getTasks();
    return tasks.where((t) => t.subjectId == subjectId).toList();
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await HiveService.instance.updateTask(task);
  }
}
