import 'package:flutter/material.dart';
import '../services/hive_service.dart';
import '../models/subject.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  final _nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subjects')),
      body: ValueListenableBuilder(
        valueListenable: HiveService.instance.subjectsListenable,
        builder: (context, box, _) {
          final subjects = HiveService.instance.getSubjects();
          if (subjects.isEmpty) return const Center(child: Text('No subjects'));
          return ListView.builder(
            itemCount: subjects.length,
            itemBuilder: (ctx, i) {
              final s = subjects[i];
              return ListTile(
                title: Text(s.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => HiveService.instance.deleteSubject(s.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Add Subject'),
            content: TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final id = DateTime.now().millisecondsSinceEpoch;
                  final s = Subject(id: id, name: _nameCtrl.text);
                  await HiveService.instance.addSubject(s);
                  _nameCtrl.clear();
                  Navigator.pop(ctx);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
