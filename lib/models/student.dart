import 'department.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';

enum Gender { male, female }

class Student {
  final String id;
  final String firstName;
  final String lastName;
  final Department department;
  final int grade;
  final Gender gender;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.department,
    required this.grade,
    required this.gender,
  });

  static Department getDepartmentById(String id) {
    return departments.firstWhere(
      (department) => department.id == id,
      orElse: () => departments.first,
    );
  }

  static Future<List<Student>> remoteGetList() async {
    final url = Uri.https(baseUrl, "$studentsPath.json");

    final response = await http.get(
      url,
    );

    if (response.statusCode >= 400) {
      throw Exception("Unable to retrieve the list of items.");
    }

    if (response.body == "null") {
      return [];
    }

    final Map<String, dynamic> data = json.decode(response.body);
    final List<Student> loadedItems = [];
    for (final item in data.entries) {
      loadedItems.add(
        Student(
          id: item.key,
          firstName: item.value['first_name']!,
          lastName: item.value['last_name']!,
          department: getDepartmentById(item.value['department']!),
          gender: Gender.values.firstWhere((v) => v.toString() == item.value['gender']!),
          grade: item.value['grade']!,
        ),
      );
    }
    return loadedItems;
  }

  static Future<Student> remoteCreate(
    firstName,
    lastName,
    department,
    gender,
    grade,
  ) async {

    final url = Uri.https(baseUrl, "$studentsPath.json");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'first_name': firstName!,
          'last_name': lastName,
          'department': department.id,
          'gender': gender.toString(),
          'grade': grade,
        },
      ),
    );

    if (response.statusCode >= 400) {
      throw Exception("Student creation process failed.");
    }

    final Map<String, dynamic> resData = json.decode(response.body);

    return Student(
        id: resData['name'],
        firstName: firstName,
        lastName: lastName,
        department: department,
        gender: gender,
        grade: grade);
  }

  static Future remoteDelete(studentId) async {
    final url = Uri.https(baseUrl, "$studentsPath/$studentId.json");

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      throw Exception("Error occurred during student deletion.");
    }
  }

  static Future<Student> remoteUpdate(
    studentId,
    firstName,
    lastName,
    department,
    gender,
    grade,
  ) async {
    final url = Uri.https(baseUrl, "$studentsPath/$studentId.json");

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'first_name': firstName!,
          'last_name': lastName,
          'department': department.id,
          'gender': gender.toString(),
          'grade': grade,
        },
      ),
    );

    if (response.statusCode >= 400) {
      throw Exception("Error while modifying student details.");
    }

    return Student(
        id: studentId,
        firstName: firstName,
        lastName: lastName,
        department: department,
        gender: gender,
        grade: grade);
  }
}