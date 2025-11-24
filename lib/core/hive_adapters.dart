import 'package:hive/hive.dart';
import '../models/subject.dart';
import '../models/task_model.dart';

Future<void> registerHiveAdapters() async {
  // Ensure adapters are registered only once in app lifecycle
  if (!Hive.isAdapterRegistered(SubjectAdapter().typeId)) {
    Hive.registerAdapter(SubjectAdapter());
  }
  if (!Hive.isAdapterRegistered(TaskModelAdapter().typeId)) {
    Hive.registerAdapter(TaskModelAdapter());
  }
}
