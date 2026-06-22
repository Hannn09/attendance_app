import 'dart:convert';

import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/admin/employee/data/models/employee_list_response.dart';
import 'package:attendance_cnn_app/features/admin/employee/data/models/employee_response.dart';
import 'package:attendance_cnn_app/core/domain/models/employee_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class EmployeeRemoteDataSource {
  final Dio dio;

  EmployeeRemoteDataSource({required this.dio});

  Future<EmployeeResponse> createEmployee(EmployeeModel data) async {
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
          // Convert List<double> to JSON string for backend
          if (data.faceEmbedding != null)
            'face_embedding': jsonEncode(data.faceEmbedding),
        });
      } else {
        requestData = data.toJson();
      }

      final response = await dio.post('/users', data: requestData);
      return EmployeeResponse.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('error create employee: ${e.response?.data}');
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

  Future<EmployeeResponse> updateEmployee(int id, EmployeeModel data) async {
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
          // Convert List<double> to JSON string for backend
          if (data.faceEmbedding != null)
            'face_embedding': jsonEncode(data.faceEmbedding),
        });
      } else {
        requestData = data.toJson();
      }

      final response = await dio.put('/users/$id', data: requestData);
      return EmployeeResponse.fromJson(response.data);
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

  Future<void> deleteEmployee(int id) async {
    try {
      await dio.delete('/users/$id');
      return;
    } on DioException catch (e) {
      debugPrint('error delete employee: ${e.response?.data}');
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

  Future<EmployeeListResponse> getAllEmployee() async {
    try {
      final response = await dio.get('/users');
      return EmployeeListResponse.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('error get all employee: ${e.response?.data}');
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
