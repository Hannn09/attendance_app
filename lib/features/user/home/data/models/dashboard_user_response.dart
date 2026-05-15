import 'package:attendance_cnn_app/features/user/home/domain/models/dashboard_users_data.dart';

class DashboardUserResponse {
  final String? message;
  final bool? success;
  final DashboardUsersData data;

  DashboardUserResponse({this.message, this.success, required this.data});

  factory DashboardUserResponse.fromJson(Map<String, dynamic> json) {
    return DashboardUserResponse(
      message: json['message'],
      success: json['success'],
      data: DashboardUsersData.fromJson(json['data'] ?? {}),
    );
  }
}
