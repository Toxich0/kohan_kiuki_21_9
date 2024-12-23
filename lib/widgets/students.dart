import 'package:flutter/material.dart';
import '../models/student.dart';
import 'student_item.dart';
import 'new_student.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final List<Student> _students = [
    Student(
      id: '1',
      firstName: 'Олексій',
      lastName: 'Петров',
      department: Department.it,
      grade: 95,
      gender: Gender.male,
    ),
    Student(
      id: '2',
      firstName: 'Ірина',
      lastName: 'Коваленко',
      department: Department.medical,
      grade: 88,
      gender: Gender.female,
    ),
  ];

  void showForm({Student? student}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return NewStudent(
          existingStudent: student,
          onSave: (updatedStudent) {
            setState(() {
              if (student != null) {
                final index = _students.indexWhere((s) => s.id == student.id);
                _students[index] = updatedStudent;
              } else {
                _students.add(updatedStudent);
              }
            });
          },
        );
      },
    );
  }

  void removeStudent(int index) {
    final removedStudent = _students[index];
    setState(() {
      _students.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removedStudent.firstName} видалено.'),
        action: SnackBarAction(
          label: 'Скасувати',
          onPressed: () {
            setState(() {
              _students.insert(index, removedStudent);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Студенти'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: _students.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(_students[index].id),
            direction: DismissDirection.endToStart,
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepOrange, Colors.amber],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    'Видалити',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            onDismissed: (_) => removeStudent(index),
            child: InkWell(
              onTap: () => showForm(student: _students[index]),
              child: StudentItem(student: _students[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showForm(),
        label: const Text('Додати студента'),
        icon: const Icon(Icons.add_box),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
