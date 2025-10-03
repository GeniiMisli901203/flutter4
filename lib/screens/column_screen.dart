import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/add_task_dialog.dart';

class ColumnScreen extends StatefulWidget {
  const ColumnScreen({super.key});

  @override
  _ColumnScreenState createState() => _ColumnScreenState();
}

class _ColumnScreenState extends State<ColumnScreen> {
  List<Task> tasks = [
    Task(
      id: '1',
      title: 'Изучить Flutter',
      description: 'Освоить основные виджеты',
      dueDate: DateTime.now().add(const Duration(days: 7)),
      priority: Priority.high,
    ),
    Task(
      id: '2',
      title: 'Купить продукты',
      description: 'Молоко, хлеб, фрукты',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: Priority.medium,
    ),
    Task(
      id: '3',
      title: 'Позвонить другу',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      priority: Priority.low,
    ),
  ];

  void _addTask() {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onAdd: (task) {
          setState(() {
            tasks.add(task);
          });
        },
      ),
    );
  }

  void _toggleTask(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  void _removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _showTaskDetails(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task.title),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Описание: ${task.description.isEmpty ? 'Нет описания' : task.description}'),
            const SizedBox(height: 8),
            Text('Срок: ${_formatDate(task.dueDate)}'),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Приоритет: '),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: task.priority.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    task.priority.text,
                    style: TextStyle(color: task.priority.color),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Простой список задач'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addTask,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Статистика
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatistic('Всего', tasks.length, Icons.list),
                  _buildStatistic('Выполнено', tasks.where((t) => t.isCompleted).length, Icons.check_circle),
                  _buildStatistic('Осталось', tasks.where((t) => !t.isCompleted).length, Icons.schedule),
                ],
              ),
            ),
            // Список задач
            Column(
              children: tasks.asMap().entries.map((entry) {
                int index = entry.key;
                Task task = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Card(
                    child: ListTile(
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) => _toggleTask(index),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                          color: task.isCompleted ? Colors.grey : Colors.black,
                        ),
                      ),
                      subtitle: Text(_formatDate(task.dueDate)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: task.priority.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeTask(index),
                          ),
                        ],
                      ),
                      onTap: () => _showTaskDetails(task),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistic(String label, int count, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}