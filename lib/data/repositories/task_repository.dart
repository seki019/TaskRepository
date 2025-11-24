import 'package:dartz/dartz.dart';
import '../../core/failures/failure.dart';
import '../datasources/task_local_data_source.dart';
import '../../models/task_model.dart';

class TaskRepository {
  TaskRepository({required this.local});

  final TaskLocalDataSource local;

  Future<Either<Failure, List<TaskModel>>> getAllTasks() async {
    try {
      final res = await local.getAllTasks();
      return Right(res);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, TaskModel?>> getTask(int id) async {
    try {
      final res = await local.getTask(id);
      if (res == null) return Left(Failure('Task not found'));
      return Right(res);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, void>> addTask(TaskModel task) async {
    try {
      await local.addTask(task);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, void>> updateTask(TaskModel task) async {
    try {
      await local.updateTask(task);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, void>> deleteTask(int id) async {
    try {
      await local.deleteTask(id);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, List<TaskModel>>> getTasksBySubject(
    int subjectId,
  ) async {
    try {
      final res = await local.getTasksBySubject(subjectId);
      return Right(res);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
