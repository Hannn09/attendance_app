import 'package:attendance_cnn_app/core/domain/models/users_model.dart';

class AuthResponse {
  final String? message;
  final bool? success;
  final String token;
  final Users user;

  AuthResponse({
    required this.message,
    required this.success,
    required this.token,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return AuthResponse(
      message: json['message'] as String?,
      success: json['success'] as bool?,
      token: data['token'] as String,
      user: Users.fromJson(data),
    );
  }
}
