import 'package:attendance_cnn_app/core/domain/models/users_model.dart';

class ProfileResponse {
  final String message;
  final bool success;
  final Users data;

  ProfileResponse({
    required this.message,
    required this.success,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      message: json['message'] as String,
      success: json['success'] as bool,
      data: Users.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
