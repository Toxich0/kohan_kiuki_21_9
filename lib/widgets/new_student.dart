import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/department.dart';

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
    const primaryColor = Colors.deepPurple;
    const secondaryTextColor = Colors.deepPurpleAccent;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.deepPurple.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  widget.existingStudent == null
                      ? 'Додати Студента'
                      : 'Редагувати Студента',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildInputField(
                controller: _firstNameController,
                label: 'Ім’я',
                primaryColor: primaryColor,
                textColor: secondaryTextColor,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _lastNameController,
                label: 'Прізвище',
                primaryColor: primaryColor,
                textColor: secondaryTextColor,
              ),
              const SizedBox(height: 16),
              _buildDropdownField<Department>(
                value: _selectedDepartment,
                label: 'Факультет',
                items: departments,
                primaryColor: primaryColor,
                textColor: secondaryTextColor,
                itemToString: (department) => department.name,
                onChanged: (value) => setState(() => _selectedDepartment = value),
              ),
              const SizedBox(height: 16),
              _buildDropdownField<Gender>(
                value: _selectedGender,
                label: 'Стать',
                items: Gender.values,
                primaryColor: primaryColor,
                textColor: secondaryTextColor,
                itemToString: (gender) =>
                    gender == Gender.male ? 'Чоловік' : 'Жінка',
                onChanged: (value) => setState(() => _selectedGender = value),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Оцінка: $_grade',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: secondaryTextColor,
                    ),
                  ),
                  Slider(
                    value: _grade.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 100,
                    activeColor: primaryColor,
                    onChanged: (value) => setState(() => _grade = value.toInt()),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Скасувати',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _save,
                    child: const Text('Зберегти'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
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
    required Color textColor,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
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
    required Color textColor,
    required String Function(T) itemToString,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(
            itemToString(item),
            style: TextStyle(color: textColor),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
