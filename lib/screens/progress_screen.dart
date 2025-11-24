import 'package:flutter/material.dart';
import '../services/hive_service.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = HiveService.instance.getTasks();
    final total = tasks.length;
    final completed = tasks.where((t) => t.isCompleted).length;
    final pending = total - completed;
    final pct = total == 0 ? 0.0 : completed / total;

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total tasks: $total'),
            Text('Completed: $completed'),
            Text('Pending: $pending'),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: pct),
            const SizedBox(height: 8),
            Text('${(pct * 100).toStringAsFixed(0)}% completed'),
          ],
        ),
      ),
    );
  }
}
