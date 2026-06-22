import 'package:attendance_cnn_app/features/user/attendance/domain/models/attendance_data.dart';

class AttendanceResponse {
  final bool? success;
  final String? message;
  final AttendanceData? data;

  AttendanceResponse({this.success, this.message, this.data});

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) =>
      AttendanceResponse(
        success: json['success'] as bool?,
        message: json['message'] as String?,
        data: json['data'] != null
            ? AttendanceData.fromMap(json['data'])
            : null,
      );
}
