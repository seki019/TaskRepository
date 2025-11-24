import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class TaskModel extends HiveObject {
  TaskModel({
    required this.id,
    required this.title,
    this.subjectId,
    this.dueDate,
    this.description,
    this.priority = 1,
    this.isCompleted = false,
  });

  @HiveField(0)
  final int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  int? subjectId;

  @HiveField(3)
  DateTime? dueDate;

  @HiveField(4)
  String? description;

  @HiveField(5)
  int priority; // 0=Low,1=Medium,2=High

  @HiveField(6)
  bool isCompleted;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskModel &&
        other.id == id &&
        other.title == title &&
        other.subjectId == subjectId &&
        other.dueDate == dueDate &&
        other.description == description &&
        other.priority == priority &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    subjectId,
    dueDate,
    description,
    priority,
    isCompleted,
  );
}

// NOTE: We include a manual adapter below to avoid build_runner/codegen in this example.
class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 1;

  @override
  TaskModel read(BinaryReader reader) {
    final id = reader.readInt();
    final title = reader.readString();
    final hasSubject = reader.readBool();
    final subjectId = hasSubject ? reader.readInt() : null;
    final hasDue = reader.readBool();
    final dueDate = hasDue
        ? DateTime.fromMillisecondsSinceEpoch(reader.readInt())
        : null;
    final hasDesc = reader.readBool();
    final description = hasDesc ? reader.readString() : null;
    final priority = reader.readInt();
    final isCompleted = reader.readBool();
    return TaskModel(
      id: id,
      title: title,
      subjectId: subjectId,
      dueDate: dueDate,
      description: description,
      priority: priority,
      isCompleted: isCompleted,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.title);
    writer.writeBool(obj.subjectId != null);
    if (obj.subjectId != null) writer.writeInt(obj.subjectId!);
    writer.writeBool(obj.dueDate != null);
    if (obj.dueDate != null)
      writer.writeInt(obj.dueDate!.millisecondsSinceEpoch);
    writer.writeBool(obj.description != null);
    if (obj.description != null) writer.writeString(obj.description!);
    writer.writeInt(obj.priority);
    writer.writeBool(obj.isCompleted);
  }
}
