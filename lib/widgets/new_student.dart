import 'package:flutter/material.dart';
import '../models/student.dart';

class NewStudent extends StatefulWidget {
  final Student? existingStudent;
  final Function(Student) onSave;

  const NewStudent({super.key, this.existingStudent, required this.onSave});

  @override
  State<NewStudent> createState() => _NewStudentState();
}

class _NewStudentState extends State<NewStudent> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  Department? _selectedDepartment;
  Gender? _selectedGender;
  int _grade = 50;

  @override
  void initState() {
    super.initState();
    if (widget.existingStudent != null) {
      _firstNameController.text = widget.existingStudent!.firstName;
      _lastNameController.text = widget.existingStudent!.lastName;
      _selectedDepartment = widget.existingStudent!.department;
      _selectedGender = widget.existingStudent!.gender;
      _grade = widget.existingStudent!.grade;
    }
  }

  void _save() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _selectedDepartment == null ||
        _selectedGender == null) {
      return;
    }

    final newStudent = Student(
      id: widget.existingStudent?.id ?? DateTime.now().toString(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      department: _selectedDepartment!,
      grade: _grade,
      gender: _selectedGender!,
    );

    widget.onSave(newStudent);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.teal;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.existingStudent == null
                    ? 'Додати Студента'
                    : 'Редагувати Студента',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _firstNameController,
                label: 'Ім’я',
                primaryColor: primaryColor,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _lastNameController,
                label: 'Прізвище',
                primaryColor: primaryColor,
              ),
              const SizedBox(height: 16),
              _buildDropdownField<Department>(
                value: _selectedDepartment,
                label: 'Факультет',
                items: Department.values,
                primaryColor: primaryColor,
                itemToString: _departmentToString,
                onChanged: (value) => setState(() => _selectedDepartment = value),
              ),
              const SizedBox(height: 16),
              _buildDropdownField<Gender>(
                value: _selectedGender,
                label: 'Стать',
                items: Gender.values,
                primaryColor: primaryColor,
                itemToString: (gender) =>
                    gender == Gender.male ? 'Чоловік' : 'Жінка',
                onChanged: (value) => setState(() => _selectedGender = value),
              ),
              const SizedBox(height: 16),
              Slider(
                value: _grade.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                label: 'Оцінка: $_grade',
                activeColor: primaryColor,
                onChanged: (value) => setState(() => _grade = value.toInt()),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.cancel),
                    label: const Text('Скасувати'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save),
                    label: const Text('Зберегти'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required Color primaryColor,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required T? value,
    required String label,
    required List<T> items,
    required Color primaryColor,
    required String Function(T) itemToString,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(itemToString(item)),
        );
      }).toList(),
      onChanged: onChanged,
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
