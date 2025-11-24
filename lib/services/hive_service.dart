import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/subject.dart';
import '../models/task_model.dart';

class HiveService {
  HiveService._privateConstructor();
  static final HiveService instance = HiveService._privateConstructor();

  late Box<Subject> _subjectBox;
  late Box<TaskModel> _taskBox;

  /// Assumes Hive.initFlutter() and adapters are already handled by caller.
  Future<void> init() async {
    _subjectBox = await Hive.openBox<Subject>('subjects');
    _taskBox = await Hive.openBox<TaskModel>('tasks');
  }

  // Subjects
  List<Subject> getSubjects() {
    return _subjectBox.values.toList();
  }

  ValueListenable get subjectsListenable => _subjectBox.listenable();

  Future<void> addSubject(Subject s) async {
    await _subjectBox.put(s.id, s);
  }

  Future<void> updateSubject(Subject s) async {
    await _subjectBox.put(s.id, s);
  }

  Future<void> deleteSubject(int id) async {
    await _subjectBox.delete(id);
  }

  // Tasks
  List<TaskModel> getTasks() {
    return _taskBox.values.toList();
  }

  ValueListenable get tasksListenable => _taskBox.listenable();

  Future<void> addTask(TaskModel t) async {
    await _taskBox.put(t.id, t);
  }

  Future<void> updateTask(TaskModel t) async {
    await _taskBox.put(t.id, t);
  }

  Future<void> deleteTask(int id) async {
    await _taskBox.delete(id);
  }
}
