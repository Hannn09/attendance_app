import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:attendance_cnn_app/widget/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddEmployeeScreen extends StatefulWidget {
  final String? employeeId;

  const AddEmployeeScreen({
    super.key,
    this.employeeId,
  });

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _employeeIdController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedDepartment;
  bool _obscurePassword = true;

  final List<String> _departments = [
    'Engineering',
    'Marketing',
    'Human Resources',
    'Finance',
    'Operations',
    'Sales',
  ];

  bool get _isEditMode => widget.employeeId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _populateForm();
    }
  }

  void _populateForm() {
    _nameController.text = 'John Doe';
    _emailController.text = 'john.doe@company.com';
    _employeeIdController.text = widget.employeeId!;
    _selectedDepartment = 'Engineering';
    _phoneNumberController.text = '+1234567890';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _employeeIdController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsetsGeometry.all(25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      LabeledTextField(
                        label: 'Full Name',
                        hint: 'Enter employee full name',
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Full name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      LabeledTextField(
                        label: 'Email',
                        hint: 'employee@company.com',
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      LabeledTextField(
                        label: 'Employee ID',
                        hint: 'EMP001',
                        controller: _employeeIdController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Employee ID is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      _buildDepartmentDropdown(),
                      SizedBox(height: 15),
                      LabeledTextField(
                        label: 'Phone Number',
                        hint: '+1234567890',
                        keyboardType: TextInputType.phone,
                        controller: _phoneNumberController,
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              !RegExp(r'^\+?[\d\s\-()]+$').hasMatch(value)) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      LabeledTextField(
                        label: 'Password ${_isEditMode ? '(Optional)' : ''}',
                        hint: 'Enter password',
                        controller: _passwordController,
                        isObsecure: _obscurePassword,
                        validator: (value) {
                          if (!_isEditMode && (value == null || value.isEmpty)) {
                            return 'Password is required';
                          }
                          if (value != null &&
                              value.isNotEmpty &&
                              value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        decoration: textFieldDecoration.copyWith(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: greyColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 25, vertical: 20),
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: blackColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: blackColor,
              ),
            ),
          ),
          SizedBox(width: 16),
          Text(
            _isEditMode ? 'Edit Employee' : 'Add Employee',
            style: semiBoldTextStyle.copyWith(fontSize: 18, color: blackColor),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentDropdown() {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          'Department',
          style: mediumTextStyle.copyWith(color: blackColor),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedDepartment,
              hint: Text(
                'Select department',
                style: hintTextStyle,
              ),
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: greyColor,
              ),
              style: regularTextStyle.copyWith(color: blackColor),
              items: _departments
                  .map(
                    (dept) => DropdownMenuItem<String>(
                      value: dept,
                      child: Text(dept),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDepartment = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _handleSubmit,
      child: Container(
        width: double.infinity,
        padding: EdgeInsetsGeometry.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, Color(0xFF799DFF)],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          _isEditMode ? 'Update Employee' : 'Save Employee',
          textAlign: .center,
          style: boldTextStyle.copyWith(
            fontSize: 16,
            color: whiteColor,
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDepartment == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please select a department',
              style: mediumTextStyle.copyWith(color: whiteColor),
            ),
            backgroundColor: redColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditMode
                ? 'Employee updated successfully'
                : 'Employee added successfully',
            style: mediumTextStyle.copyWith(color: whiteColor),
          ),
          backgroundColor: greenColor,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Future.delayed(Duration(milliseconds: 500)).then((_) {
        if (mounted) {
          context.pop();
        }
      });
    }
  }
}
