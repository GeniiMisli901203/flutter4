import 'package:flutter/material.dart';

import 'ColumnScreen.dart';
import 'ListViewScreen.dart';
import 'ListViewSeparatedScreen.dart';

class MainScreen extends StatefulWidget{
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ColumnScreen(),
    const ListViewScreen(),
    const ListViewSeparatedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Fourth Practice'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.green,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.text_fields),
            activeIcon: Icon(Icons.text_fields, color: Colors.green),
            label: 'Column',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.smart_button),
            activeIcon: Icon(Icons.smart_button, color: Colors.green),
            label: 'ListView',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            activeIcon: Icon(Icons.grid_view, color: Colors.green),
            label: 'ListViewSeparated',
          ),
        ],
      ),
    );
  }
}