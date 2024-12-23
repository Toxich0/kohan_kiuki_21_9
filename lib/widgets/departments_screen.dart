import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/department.dart';
import '../providers/students_provider.dart';

class DepartmentsScreen extends ConsumerWidget {
  const DepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);

    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final department = departments[index];
          final studentCount = students
              .where((student) => student.department.id == department.id)
              .length;

          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(department.icon, size: 40, color: department.color),
                const SizedBox(height: 8),
                Text(
                  department.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: department.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$studentCount студентів',
                  style: TextStyle(
                    color: department.color.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
