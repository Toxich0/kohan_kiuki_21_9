import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';

class StudentsState {
  final List<Student> studentsList;
  final bool isRequestingToServer;
  final String? errorOccured;

  StudentsState({
    required this.studentsList,
    required this.isRequestingToServer,
    this.errorOccured,
  });

  StudentsState copyWith({
    List<Student>? studentsList,
    bool? isRequestingToServer,
    String? errorOccured,
  }) {
    return StudentsState(
      studentsList: studentsList ?? this.studentsList,
      isRequestingToServer: isRequestingToServer ?? this.isRequestingToServer,
      errorOccured: errorOccured ?? this.errorOccured,
    );
  }
}

class StudentsNotifier extends StateNotifier<StudentsState> {
  StudentsNotifier() : super(StudentsState(studentsList: [], isRequestingToServer: false));

  Student? _lastRemovedStudent;
  int? _lastRemovedIndex;

  Future<void> loadStudents() async {
    state = state.copyWith(isRequestingToServer: true, errorOccured: null);
    try {
      final studentsList = await Student.remoteGetList();
      state = state.copyWith(studentsList: studentsList, isRequestingToServer: false);
    } catch (e) {
      state = state.copyWith(
        isRequestingToServer: false,
        errorOccured: e.toString(),
      );
    }
  }

  Future<void> addStudent(
    String firstName,
    String lastName,
    department,
    gender,
    int grade,
  ) async {
    try {
      state = state.copyWith(isRequestingToServer: true, errorOccured: null);
      final student = await Student.remoteCreate(
          firstName, lastName, department, gender, grade);
      state = state.copyWith(
        studentsList: [...state.studentsList, student],
        isRequestingToServer: false,
      );
    } catch (e) {
      state = state.copyWith(
        isRequestingToServer: false,
        errorOccured: e.toString(),
      );
    }
  }

  Future<void> updateStudent(
    int index,
    String firstName,
    String lastName,
    department,
    gender,
    int grade,
  ) async {
    state = state.copyWith(isRequestingToServer: true, errorOccured: null);
    try {
      final updatedStudent = await Student.remoteUpdate(
        state.studentsList[index].id,
        firstName,
        lastName,
        department,
        gender,
        grade,
      );
      final updatedList = [...state.studentsList];
      updatedList[index] = updatedStudent;
      state = state.copyWith(studentsList: updatedList, isRequestingToServer: false);
    } catch (e) {
      state = state.copyWith(
        isRequestingToServer: false,
        errorOccured: e.toString(),
      );
    }
  }

  void deleteStudent(int index) {
    _lastRemovedStudent = state.studentsList[index];
    _lastRemovedIndex = index;
    final updatedList = [...state.studentsList];
    updatedList.removeAt(index);
    state = state.copyWith(studentsList: updatedList);
  }

  void undoStudent() {
    if (_lastRemovedStudent != null && _lastRemovedIndex != null) {
      final updatedList = [...state.studentsList];
      updatedList.insert(_lastRemovedIndex!, _lastRemovedStudent!);
      state = state.copyWith(studentsList: updatedList);
    }
  }

  Future<void> removeFirebase() async {
    state = state.copyWith(isRequestingToServer: true, errorOccured: null);
    try {
      if (_lastRemovedStudent != null) {
        await Student.remoteDelete(_lastRemovedStudent!.id);
        _lastRemovedStudent = null;
        _lastRemovedIndex = null;
      }
      state = state.copyWith(isRequestingToServer: false);
    } catch (e) {
      state = state.copyWith(
        isRequestingToServer: false,
        errorOccured: e.toString(),
      );
    }
  }
}

final studentsProvider =
    StateNotifierProvider<StudentsNotifier, StudentsState>((ref) {
  final notifier = StudentsNotifier();
  notifier.loadStudents();
  return notifier;
});
