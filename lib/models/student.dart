import 'package:flutter/material.dart';
import '../models/department.dart';

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
}
