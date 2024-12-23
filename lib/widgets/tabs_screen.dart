import 'package:flutter/material.dart';
import 'students.dart';
import 'departments_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;

  final List<String> _titles = ['Факультети', 'Студенти'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 3,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: _selectedIndex == 0
          ? const DepartmentsScreen() // Здесь не передаем параметры.
          : const StudentsScreen(),    // Здесь тоже не передаем параметры.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        backgroundColor: Colors.white,
        elevation: 5,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_work_rounded),
            label: 'Факультети',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_rounded),
            label: 'Студенти',
          ),
        ],
      ),
    );
  }
}
