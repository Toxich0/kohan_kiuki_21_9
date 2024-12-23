import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';

class StudentsNotifier extends StateNotifier<List<Student>> {
  StudentsNotifier() : super([]);

  void addStudent(Student student) {
    state = [...state, student];
  }

  void updateStudent(Student updatedStudent) {
    state = state.map((student) {
      if (student.id == updatedStudent.id) {
        return updatedStudent;
      }
      return student;
    }).toList();
  }

  void deleteStudent(String id) {
    state = state.where((student) => student.id != id).toList();
  }

  void undoStudent(Student student) {
    state = [...state, student];
  }
}

final studentsProvider = StateNotifierProvider<StudentsNotifier, List<Student>>(
  (ref) => StudentsNotifier(),
);
