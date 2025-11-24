import 'package:flutter/material.dart';
import '../services/hive_service.dart';
import '../models/task_model.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0; // 0=All,1=Today,2=Completed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Planner')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(child: Text('Menu')),
            ListTile(
              title: const Text('Subjects'),
              onTap: () => Navigator.pushNamed(context, '/subjects'),
            ),
            ListTile(
              title: const Text('Progress'),
              onTap: () => Navigator.pushNamed(context, '/progress'),
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: HiveService.instance.tasksListenable,
        builder: (context, box, _) {
          final tasks = HiveService.instance.getTasks();
          final now = DateTime.now();
          List<TaskModel> filtered = tasks;
          if (_tabIndex == 1) {
            filtered = tasks
                .where(
                  (t) =>
                      t.dueDate != null &&
                      t.dueDate!.year == now.year &&
                      t.dueDate!.month == now.month &&
                      t.dueDate!.day == now.day,
                )
                .toList();
          } else if (_tabIndex == 2) {
            filtered = tasks.where((t) => t.isCompleted).toList();
          } else {
            filtered = tasks.where((t) => !t.isCompleted).toList();
          }

          filtered.sort((a, b) {
            final da = a.dueDate ?? DateTime.fromMillisecondsSinceEpoch(0);
            final db = b.dueDate ?? DateTime.fromMillisecondsSinceEpoch(0);
            return da.compareTo(db);
          });

          if (filtered.isEmpty) {
            return const Center(child: Text('No tasks'));
          }

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final t = filtered[index];
              return ListTile(
                leading: Icon(
                  t.isCompleted ? Icons.check_circle : Icons.schedule,
                  color: t.isCompleted ? Colors.green : Colors.orange,
                ),
                title: Text(t.title),
                subtitle: Text(
                  t.dueDate != null ? '${t.dueDate}' : 'No due date',
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) async {
                    if (v == 'edit') {
                      // edit not implemented yet
                    } else if (v == 'delete') {
                      await HiveService.instance.deleteTask(t.id);
                    } else if (v == 'complete') {
                      t.isCompleted = !t.isCompleted;
                      await HiveService.instance.updateTask(t);
                    }
                  },
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(
                      value: 'complete',
                      child: Text('Toggle Complete'),
                    ),
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (i) => setState(() => _tabIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'All'),
          BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Completed'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddTaskScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
