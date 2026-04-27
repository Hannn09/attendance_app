import 'package:attendance_cnn_app/core/data/local/auth_local_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource localDataSource;
  AuthInterceptor({required this.localDataSource});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await localDataSource.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      debugPrint('Unauthorized! Clearing logged in user data.');
    }
    super.onError(err, handler);
  }
}
