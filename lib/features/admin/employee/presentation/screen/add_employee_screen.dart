import 'dart:io';

import 'package:attendance_cnn_app/core/domain/models/employee_model.dart';
import 'package:attendance_cnn_app/features/admin/employee/presentation/providers/employee_action_notifier.dart';
import 'package:attendance_cnn_app/features/admin/employee/presentation/providers/employee_list_notifier.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:attendance_cnn_app/widget/labeled_text_field.dart';
import 'package:attendance_cnn_app/widget/loading_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AddEmployeeScreen extends ConsumerStatefulWidget {
  final String? employeeId;

  const AddEmployeeScreen({super.key, this.employeeId});

  @override
  ConsumerState<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends ConsumerState<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _imagePicker = ImagePicker();
  bool _obscurePassword = true;
  File? _facePictureFile;
  String? _existingFacePicturePath;

  bool get _isEditMode => widget.employeeId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      // Populate after first frame to ensure providers are ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _populateForm();
      });
    }
  }

  void _populateForm() {
    if (!_isEditMode) return;

    final employeeId = int.tryParse(widget.employeeId!) ?? 0;
    if (employeeId == 0) return;

    final employeeListState = ref.read(employeeListNotifierProvider);

    employeeListState.when(
      data: (employees) {
        final employee = employees.firstWhere(
          (e) => e.id == employeeId,
          orElse: () => throw Exception('Employee not found'),
        );

        if (mounted) {
          _nameController.text = employee.name;
          _usernameController.text = employee.username;
          _existingFacePicturePath = employee.facePicturePath;
        }
      },
      loading: () {},
      error: (error, stackTrace) {},
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actionState = ref.watch(employeeActionNotifierProvider);

    ref.listen(employeeActionNotifierProvider, (previous, next) async {
      if (next.hasError && context.mounted) {
        await ScaffoldMessenger.of(context)
            .showSnackBar(
              SnackBar(
                content: Text(
                  next.error.toString(),
                  style: mediumTextStyle.copyWith(color: whiteColor),
                ),
                backgroundColor: redColor,
                behavior: SnackBarBehavior.floating,
              ),
            )
            .closed;
        ref.read(employeeActionNotifierProvider.notifier).reset();
      } else if (next.hasValue &&
          previous != null &&
          previous.isLoading &&
          context.mounted) {
        await ScaffoldMessenger.of(context)
            .showSnackBar(
              SnackBar(
                content: Text(
                  _isEditMode
                      ? 'Employee updated successfully'
                      : 'Employee added successfully',
                  style: mediumTextStyle.copyWith(color: whiteColor),
                ),
                backgroundColor: greenColor,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
              ),
            )
            .closed;
        if (context.mounted) context.pop();
      }
    });

    return Stack(
      children: [
        Scaffold(
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
                          _buildFacePictureUpload(),
                          SizedBox(height: 25),
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
                            label: 'Username',
                            hint: 'Enter employee username',
                            keyboardType: TextInputType.text,
                            controller: _usernameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Username is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15),

                          LabeledTextField(
                            label:
                                'Password ${_isEditMode ? '(Optional)' : ''}',
                            hint: 'Enter password',
                            controller: _passwordController,
                            isObsecure: _obscurePassword,
                            validator: (value) {
                              if (!_isEditMode &&
                                  (value == null || value.isEmpty)) {
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
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: _buildSubmitButton(actionState.isLoading),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
        if (actionState.isLoading) const LoadingStateWidget(),
      ],
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
              margin: EdgeInsets.only(right: 10),
              width: 40,
              height: 40,
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: blackColor,
              ),
            ),
          ),
          Text(
            _isEditMode ? 'Edit Employee' : 'Add Employee',
            style: semiBoldTextStyle.copyWith(fontSize: 18, color: blackColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    return GestureDetector(
      onTap: isLoading ? null : _handleSubmit,
      child: Container(
        width: double.infinity,
        padding: EdgeInsetsGeometry.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isLoading ? greyColor : primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          isLoading
              ? 'Loading...'
              : (_isEditMode ? 'Update Employee' : 'Save Employee'),
          textAlign: .center,
          style: boldTextStyle.copyWith(fontSize: 16, color: whiteColor),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final employee = EmployeeModel(
        id: 0,
        name: _nameController.text,
        username: _usernameController.text,
        facePictureFile: _facePictureFile,
        password: _passwordController.text.isNotEmpty
            ? _passwordController.text
            : null,
      );

      if (_isEditMode) {
        final employeeId = int.tryParse(widget.employeeId!) ?? 0;
        ref
            .read(employeeActionNotifierProvider.notifier)
            .updateEmployee(employeeId, employee);
      } else {
        ref
            .read(employeeActionNotifierProvider.notifier)
            .createEmployee(employee);
      }
    }
  }

  Widget _buildFacePictureUpload() {
    final hasImage =
        _facePictureFile != null || _existingFacePicturePath != null;

    return Column(
      children: [
        GestureDetector(
          onTap: _showImagePickerBottomSheet,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: greyColor.withValues(alpha: 0.1),
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Stack(
              children: [
                Center(
                  child: hasImage
                      ? ClipOval(
                          child: _facePictureFile != null
                              ? Image.file(
                                  _facePictureFile!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                )
                              : _existingFacePicturePath != null
                              ? Image.network(
                                  _existingFacePicturePath!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.person,
                                      size: 50,
                                      color: greyColor,
                                    );
                                  },
                                )
                              : null,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              size: 32,
                              color: greyColor,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Add Photo',
                              style: regularTextStyle.copyWith(
                                fontSize: 12,
                                color: greyColor,
                              ),
                            ),
                          ],
                        ),
                ),
                if (hasImage)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _removeFacePicture,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: redColor,
                        ),
                        child: Icon(Icons.close, color: whiteColor, size: 16),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Tap to add face picture',
          style: regularTextStyle.copyWith(fontSize: 12, color: lightGreyColor),
        ),
      ],
    );
  }

  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            Text(
              'Select Image Source',
              style: semiBoldTextStyle.copyWith(fontSize: 16),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.camera_alt_outlined, color: primaryColor),
              title: Text('Camera', style: mediumTextStyle),
              onTap: () async {
                context.pop();
                await Future.delayed(Duration(milliseconds: 300));
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library_outlined, color: primaryColor),
              title: Text('Gallery', style: mediumTextStyle),
              onTap: () async {
                context.pop();
                await Future.delayed(Duration(milliseconds: 300));
                _pickImage(ImageSource.gallery);
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        final compressedFile = await _compressImage(File(pickedFile.path));
        if (mounted) {
          setState(() {
            _facePictureFile = compressedFile;
          });
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to pick image. Please try again.',
              style: mediumTextStyle.copyWith(color: whiteColor),
            ),
            backgroundColor: redColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<File> _compressImage(File file) async {
    try {
      final compressedFilePath = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        '${file.parent.path}/temp_${DateTime.now().millisecondsSinceEpoch}.jpg',
        quality: 85,
        minWidth: 800,
        minHeight: 800,
        format: CompressFormat.jpeg,
      );

      if (compressedFilePath != null) {
        return File(compressedFilePath.path);
      }
    } catch (e) {
      debugPrint('Error compressing image: $e');
    }
    return file;
  }

  void _removeFacePicture() {
    setState(() {
      _facePictureFile = null;
      _existingFacePicturePath = null;
    });
  }
}
