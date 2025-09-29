import 'package:flutter/material.dart';

class ListViewScreen extends StatefulWidget {
  const ListViewScreen({super.key});

  @override
  _ListViewScreenState createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  List<String> items = List.generate(10, (index) => 'Элемент ${index + 1}');

  void addItem() {
    setState(() {
      items.add('Элемент ${items.length + 1}');
    });
  }

  void removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Уведомление'),
          content: Text('Спасибо! Ты молодец!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
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
        title: Text('Список с ListView'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: addItem,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            key: ValueKey(items[index]),
            title: Text(items[index]),
            trailing: IconButton(
              icon: Icon(Icons.remove),
              onPressed: () => removeItem(index),
            ),
            onTap: () => _showDialog(context),
          );
        },
      ),
    );
  }
}