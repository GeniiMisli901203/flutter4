import 'package:flutter/material.dart';

class ListViewSeparatedScreen extends StatefulWidget {
  const ListViewSeparatedScreen({super.key});

  @override
  _ListViewSeparatedScreenState createState() => _ListViewSeparatedScreenState();
}

class _ListViewSeparatedScreenState extends State<ListViewSeparatedScreen> {
  List<String> items = List.generate(10, (index) => 'Элемент ${index + 1}');
  int _next_id = 11;

  void addItem() {
    setState(() {
      items.add('Элемент ${_next_id}');
      _next_id++;
    });
  }

  void removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }
  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Удаление'),
          content: Text('Вы уверены, что хотите удалить "${items[index]}"?'),
          actions: [
            TextButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Удалить',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                removeItem(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список с ListView.separated'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: addItem,
          )
        ],
      ),
      body: ListView.separated(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPress: () {
              _showDeleteConfirmationDialog(index);
            },
            child: Container(
              color: Colors.transparent,
              child: ListTile(
                key: ValueKey(items[index]),
                title: Text(
                  items[index],
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: Text('Нажмите для информации, удерживайте для удаления'),
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min
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
        onPressed: addItem,
        child: Icon(Icons.add),
        tooltip: 'Добавить элемент',
      ),
    );
  }
}