import 'package:flutter/material.dart';

class ColumnScreen extends StatefulWidget {
  const ColumnScreen({super.key});

  @override
  _ColumnScreenState createState() => _ColumnScreenState();
}

class _ColumnScreenState extends State<ColumnScreen> {
  // Список элементов
  List<String> items = List.generate(10, (index) => 'Item ${index + 1}');

  // Метод для добавления элемента
  void addItem() {
    setState(() {
      items.add('Item ${items.length + 1}');
    });
  }

  // Метод для удаления элемента по индексу
  void removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список элементов'),
        actions: [
          // Кнопка добавления сверху справа
          IconButton(
            icon: Icon(Icons.add),
            onPressed: addItem,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Отображение списка элементов с кнопками удаления
            Column(
              children: items.asMap().entries.map((entry) {
                int index = entry.key;
                String item = entry.value;
                return Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => removeItem(index),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
