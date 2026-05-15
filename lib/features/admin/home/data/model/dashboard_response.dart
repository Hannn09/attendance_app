import 'package:attendance_cnn_app/features/admin/home/domain/models/dashboard_data.dart';

class DashboardResponse {
  final String? message;
  final bool? success;
  final DashboardData data;

  DashboardResponse({this.message, this.success, required this.data});

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      message: json['message'],
      success: json['success'],
      data: DashboardData.fromJson(json['data']),
    );
  }
}
