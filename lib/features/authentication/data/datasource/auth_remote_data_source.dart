import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/authentication/data/models/auth_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource({required this.dio});

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/login',
        data: {'username': email, 'password': password},
      );
      debugPrint('response login: ${response.data}');
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('error login: ${e.response?.data}');
      throw Failure(
        e.response?.data['message'] as String? ??
            'An unexpected error occurred',
      );
    } catch (e, stacktrace) {
      debugPrint("PARSING ERROR DETAIL: $e");
      debugPrint("STACKTRACE: $stacktrace");
      throw Failure("Data format error: $e");
    }
  }

  Future<void> logout() async {
    try {
      await dio.post('/logout');
    } on DioException catch (e) {
      debugPrint('error logout: ${e.response?.data}');
      throw Failure(
        e.response?.data['message'] as String? ??
            'An unexpected error occurred',
      );
    } catch (e, stacktrace) {
      debugPrint("PARSING ERROR DETAIL: $e");
      debugPrint("STACKTRACE: $stacktrace");
      throw Failure("Data format error: $e");
    }
  }
}
