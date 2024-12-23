import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';
import '../providers/students_provider.dart';
import 'student_item.dart';
import 'new_student.dart';

class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({super.key});

  void _showNewStudentForm(BuildContext context, WidgetRef ref, {Student? student}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return NewStudent(
          existingStudent: student,
          onSave: (updatedStudent) {
            final notifier = ref.read(studentsProvider.notifier);
            if (student != null) {
              notifier.updateStudent(updatedStudent);
            } else {
              notifier.addStudent(updatedStudent);
            }
          },
        );
      },
    );
  }

  void _deleteStudent(BuildContext context, WidgetRef ref, Student student) {
    final notifier = ref.read(studentsProvider.notifier);
    notifier.deleteStudent(student.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${student.firstName} видалено.'),
        action: SnackBarAction(
          label: 'Скасувати',
          onPressed: () => notifier.undoStudent(student),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);

    return Scaffold(
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Dismissible(
            key: ValueKey(student.id),
            direction: DismissDirection.endToStart,
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade400, Colors.red.shade700],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete_forever, color: Colors.white, size: 28),
                  const SizedBox(width: 10),
                  const Text(
                    'Видалити',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            onDismissed: (_) => _deleteStudent(context, ref, student),
            child: InkWell(
              onTap: () => _showNewStudentForm(context, ref, student: student),
              child: StudentItem(student: student),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewStudentForm(context, ref),
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
