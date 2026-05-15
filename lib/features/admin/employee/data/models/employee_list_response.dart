import 'package:attendance_cnn_app/core/domain/models/employee_model.dart';

class EmployeeListResponse {
  final String message;
  final bool success;
  final List<EmployeeModel> data;

  EmployeeListResponse({
    required this.message,
    required this.success,
    required this.data,
  });

  factory EmployeeListResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeListResponse(
      message: json['message'],
      success: json['success'],
      data: (json['data'] as List)
          .map((e) => EmployeeModel.fromJson(e))
          .toList(),
    );
  }
}
