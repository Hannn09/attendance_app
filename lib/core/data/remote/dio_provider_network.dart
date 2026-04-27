import 'package:attendance_cnn_app/config/app_config.dart';
import 'package:attendance_cnn_app/core/data/remote/auth_interceptor.dart';
import 'package:attendance_cnn_app/features/authentication/domain/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 180),
      receiveTimeout: const Duration(seconds: 180),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );
  dio.interceptors.add(
    AuthInterceptor(localDataSource: ref.read(authLocalDataSource)),
  );
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      request: true,
      logPrint: (obj) => debugPrint(obj.toString()),
    ),
  );

  return dio;
});
