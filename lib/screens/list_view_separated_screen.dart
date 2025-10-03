import 'package:flutter/material.dart';

import '../models/task.dart';
import '../widgets/add_task_dialog.dart';

class ListViewSeparatedScreen extends StatefulWidget {
  const ListViewSeparatedScreen({super.key});

  @override
  _ListViewSeparatedScreenState createState() => _ListViewSeparatedScreenState();
}

class _ListViewSeparatedScreenState extends State<ListViewSeparatedScreen> {
  List<Task> tasks = [
    Task(
      id: '1',
      title: 'Завершить проект',
      description: 'Финальные правки и тестирование',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      priority: Priority.high,
    ),
    Task(
      id: '2',
      title: 'Оплатить счета',
      description: 'Коммунальные услуги и интернет',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: Priority.medium,
    ),
    Task(
      id: '3',
      title: 'Сходить в спортзал',
      dueDate: DateTime.now().add(const Duration(days: 2)),
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

  void _removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удаление задачи'),
          content: Text('Вы уверены, что хотите удалить "${tasks[index].title}"?'),
          actions: [
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Удалить',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                _removeTask(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showTaskDetails(int index) {
    final task = tasks[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Описание', task.description.isEmpty ? 'Нет описания' : task.description),
              _buildDetailRow('Срок выполнения', _formatDate(task.dueDate)),
              _buildDetailRow('Приоритет', task.priority.text),
              _buildDetailRow('Статус', task.isCompleted ? 'Выполнено' : 'В процессе'),
              const SizedBox(height: 16),
              Text(
                'Осталось дней: ${task.dueDate.difference(DateTime.now()).inDays}',
                style: TextStyle(
                  color: _getRemainingDaysColor(task.dueDate),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  Color _getRemainingDaysColor(DateTime dueDate) {
    final remainingDays = dueDate.difference(DateTime.now()).inDays;
    if (remainingDays <= 1) return Colors.red;
    if (remainingDays <= 3) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детальный просмотр задач'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addTask,
          )
        ],
      ),
      body: ListView.separated(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return GestureDetector(
            onLongPress: () {
              _showDeleteConfirmationDialog(index);
            },
            onTap: () {
              _showTaskDetails(index);
            },
            child: Container(
              color: Colors.transparent,
              child: ListTile(
                key: ValueKey(task.id),
                leading: CircleAvatar(
                  backgroundColor: task.priority.color,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  task.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.description.isEmpty ? 'Без описания' : task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(task.dueDate),
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.flag, size: 14, color: task.priority.color),
                        const SizedBox(width: 4),
                        Text(
                          task.priority.text,
                          style: TextStyle(fontSize: 12, color: task.priority.color),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Icon(
                  task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: task.isCompleted ? Colors.green : Colors.grey,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey[300],
            height: 1,
            thickness: 1,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
        tooltip: 'Добавить задачу',
      ),
    );
  }
}