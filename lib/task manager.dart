class TaskManager {
  List<String> tasks = [];

  void loadTasks() {
    print('TaskManager: Loading tasks...');
  }

  void addTask(String task) {
    tasks.add(task);
    print('TaskManager: "$task" added to your task list.');
  }
}
