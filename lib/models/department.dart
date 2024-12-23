import 'package:flutter/material.dart';

class Department {
  final String id;
  final String name;
  final Color color;
  final IconData icon;

  Department({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });
}

List<Department> departments = [
  Department(
    id: '1',
    name: 'Фінанси',
    color: Colors.green,
    icon: Icons.account_balance_wallet,
  ),
  Department(
    id: '2',
    name: 'Юриспруденція',
    color: Colors.blue,
    icon: Icons.balance,
  ),
  Department(
    id: '3',
    name: 'ІТ',
    color: Colors.purple,
    icon: Icons.developer_mode,
  ),
  Department(
    id: '4',
    name: 'Медицина',
    color: Colors.red,
    icon: Icons.healing,
  ),
];
