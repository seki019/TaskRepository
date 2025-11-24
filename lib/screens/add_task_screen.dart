import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/hive_service.dart';
import '../models/task_model.dart';
import '../models/subject.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime? _dueDate;
  int _priority = 1;
  int? _subjectId;

  @override
  Widget build(BuildContext context) {
    final subjects = HiveService.instance.getSubjects();

    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int?>(
                initialValue: _subjectId,
                hint: const Text('Select subject'),
                items: subjects
                    .map(
                      (s) => DropdownMenuItem(value: s.id, child: Text(s.name)),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _subjectId = v),
              ),
              const SizedBox(height: 8),
              ListTile(
                title: Text(
                  _dueDate != null
                      ? DateFormat.yMd().format(_dueDate!)
                      : 'No due date',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (d != null) setState(() => _dueDate = d);
                  },
                ),
              ),
              DropdownButtonFormField<int>(
                initialValue: _priority,
                items: const [
                  DropdownMenuItem(value: 0, child: Text('Low')),
                  DropdownMenuItem(value: 1, child: Text('Medium')),
                  DropdownMenuItem(value: 2, child: Text('High')),
                ],
                onChanged: (v) => setState(() => _priority = v ?? 1),
                decoration: const InputDecoration(labelText: 'Priority'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final id = DateTime.now().millisecondsSinceEpoch;
                  final t = TaskModel(
                    id: id,
                    title: _titleCtrl.text,
                    subjectId: _subjectId,
                    dueDate: _dueDate,
                    description: _descCtrl.text.isEmpty ? null : _descCtrl.text,
                    priority: _priority,
                  );
                  await HiveService.instance.addTask(t);
                  Navigator.pop(context);
                },
                child: const Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
