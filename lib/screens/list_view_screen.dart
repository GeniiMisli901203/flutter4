import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/add_task_dialog.dart';

class ListViewScreen extends StatefulWidget {
  const ListViewScreen({super.key});

  @override
  _ListViewScreenState createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  List<Task> tasks = [
    Task(
      id: '1',
      title: 'Подготовить презентацию',
      description: 'Для совещания в понедельник',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      priority: Priority.high,
    ),
    Task(
      id: '2',
      title: 'Записаться к врачу',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      priority: Priority.medium,
    ),
    Task(
      id: '3',
      title: 'Прочитать книгу',
      description: 'Глава 5-6',
      dueDate: DateTime.now().add(const Duration(days: 10)),
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

  void _showCompletionDialog(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(task.isCompleted ? 'Задача выполнена!' : 'Задача не выполнена'),
          content: Text(task.isCompleted
              ? 'Отличная работа! "${task.title}" выполнена!'
              : 'Не забудьте выполнить "${task.title}" до ${_formatDate(task.dueDate)}'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    // Сортируем задачи по приоритету
    tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Задачи по приоритетам'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addTask,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Dismissible(
            key: ValueKey(task.id),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => _removeTask(index),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: _getTaskColor(task),
              child: ListTile(
                leading: IconButton(
                  icon: Icon(
                    task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: task.isCompleted ? Colors.green : Colors.grey,
                  ),
                  onPressed: () => _toggleTask(index),
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Срок: ${_formatDate(task.dueDate)}'),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.flag, size: 16, color: task.priority.color),
                        const SizedBox(width: 4),
                        Text(
                          task.priority.text,
                          style: TextStyle(color: task.priority.color),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showCompletionDialog(task),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getTaskColor(Task task) {
    if (task.isCompleted) return Colors.grey[100]!;
    switch (task.priority) {
      case Priority.high:
        return Colors.red[50]!;
      case Priority.medium:
        return Colors.orange[50]!;
      case Priority.low:
        return Colors.green[50]!;
    }
  }
}