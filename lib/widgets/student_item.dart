import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentItem extends StatelessWidget {
  final Student student;

  const StudentItem({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = student.gender == Gender.male
        ? Colors.blue.shade100
        : Colors.pink.shade100;
    final borderColor = student.gender == Gender.male
        ? Colors.blue.shade700
        : Colors.pink.shade700;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${student.firstName} ${student.lastName}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: borderColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _departmentToString(student.department),
                  style: TextStyle(
                    fontSize: 14,
                    color: borderColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${student.grade}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: borderColor,
                  ),
                ),
                const SizedBox(height: 8),
                Icon(
                  departmentIcons[student.department],
                  size: 24,
                  color: borderColor.withOpacity(0.8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _departmentToString(Department department) {
    switch (department) {
      case Department.finance:
        return 'Фінанси';
      case Department.law:
        return 'Юриспруденція';
      case Department.it:
        return 'ІТ';
      case Department.medical:
        return 'Медицина';
      default:
        return '';
    }
  }
}
