import 'dart:convert';

import 'package:attendance_cnn_app/core/domain/models/employee_model.dart';
import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ProfileUserRemoteDataSource {
  final Dio dio;

  ProfileUserRemoteDataSource({required this.dio});

  Future<void> updateProfile(EmployeeModel data) async {
    try {
      late final dynamic requestData;

      if (data.facePictureFile != null) {
        final bytes = await data.facePictureFile!.readAsBytes();
        requestData = FormData.fromMap({
          'username': data.username,
          'name': data.name,
          if (data.password != null && data.password!.isNotEmpty)
            'password': data.password,
          'role': data.role ?? 'karyawan',
          'face_picture': MultipartFile.fromBytes(
            bytes,
            filename: 'face_picture.jpg',
          ),
          // Convert List<double> to JSON array string for backend
          if (data.faceEmbedding != null)
            'face_embedding': jsonEncode(data.faceEmbedding),
        });
      } else {
        requestData = data.toJson();
      }

      final response = await dio.put('/me/update', data: requestData);
      return response.data;
    } on DioException catch (e) {
      debugPrint('error update employee: ${e.response?.data}');
      throw Failure(
        e.response?.data['message'] as String? ??
            'An unexpected error occurred',
      );
    } catch (e, stacktrace) {
      debugPrint("error: $e");
      debugPrint("stackrace: $stacktrace");
      throw Failure("Data format error: $e");
    }
  }
}
