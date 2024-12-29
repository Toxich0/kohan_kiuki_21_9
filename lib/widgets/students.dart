import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';
import '../providers/students_provider.dart';
import 'student_item.dart';
import 'new_student.dart';

class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({super.key});

  void _showNewStudentForm(BuildContext context, WidgetRef ref, {int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return NewStudent(studentIndex: index,);
      },
    );
  }

  void _deleteStudent(BuildContext context, WidgetRef ref, Student student, int index) {
    final notifier = ref.read(studentsProvider.notifier);
    final provideScope = ProviderScope.containerOf(context);
    notifier.deleteStudent(index);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${student.firstName} видалено.'),
        action: SnackBarAction(
          label: 'Скасувати',
          onPressed: () => notifier.undoStudent(),
        ),
      ),
    ).closed.then((value) {
      if (value != SnackBarClosedReason.action) {
        provideScope.read(studentsProvider.notifier).removeFirebase();
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsState = ref.watch(studentsProvider);

    if (studentsState.isRequestingToServer) {
      return const Center(child: CircularProgressIndicator());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (studentsState.errorOccured != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              studentsState.errorOccured!,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      body: ListView.builder(
        itemCount: studentsState.studentsList.length,
        itemBuilder: (context, index) {
          final student = studentsState.studentsList[index];
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
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete_forever, color: Colors.white, size: 28),
                  SizedBox(width: 10),
                  Text(
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
            onDismissed: (_) => _deleteStudent(context, ref, student, index),
            child: InkWell(
              onTap: () => _showNewStudentForm(context, ref, index: index),
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
