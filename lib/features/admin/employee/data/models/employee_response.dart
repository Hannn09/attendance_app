import 'package:attendance_cnn_app/core/domain/models/employee_model.dart';

class EmployeeResponse {
  final String message;
  final bool success;
  final EmployeeModel employee;

  EmployeeResponse({
    required this.message,
    required this.success,
    required this.employee,
  });

  factory EmployeeResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeResponse(
      message: json['message'],
      success: json['success'],
      employee: EmployeeModel.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'success': success,
      'employee': employee.toJson(),
    };
  }
}
