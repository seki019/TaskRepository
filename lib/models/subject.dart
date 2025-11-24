import 'package:hive/hive.dart';

class Subject {
  Subject({required this.id, required this.name});

  final int id;
  String name;
}

class SubjectAdapter extends TypeAdapter<Subject> {
  @override
  final int typeId = 0;

  @override
  Subject read(BinaryReader reader) {
    final id = reader.readInt();
    final name = reader.readString();
    return Subject(id: id, name: name);
  }

  @override
  void write(BinaryWriter writer, Subject obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.name);
  }
}
