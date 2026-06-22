import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/user/attendance/data/models/attendance_response.dart';
import 'package:attendance_cnn_app/features/user/attendance/domain/models/attendance_data.dart';
import 'package:attendance_cnn_app/features/user/attendance/domain/models/attendance_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class AttendanceRemoteDataSource {
  final Dio dio;

  AttendanceRemoteDataSource({required this.dio});

  Future<void> checkIn(AttendanceRequest request) async {
    try {
      final bytes = await request.photoFile.readAsBytes();
      final requestData = FormData.fromMap({
        'user_id': request.userId,
        'latitude': request.latitude,
        'longitude': request.longitude,
        'note': request.note,
        'photo': MultipartFile.fromBytes(
          bytes,
          filename: 'checkin_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      });

      final response = await dio.post(
        '/attendance/check-in',
        data: requestData,
      );
      return response.data;
    } on DioException catch (e) {
      debugPrint('error checkin: ${e.response?.data}');
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

  Future<void> checkOut(AttendanceRequest request) async {
    try {
      final bytes = await request.photoFile.readAsBytes();
      final requestData = FormData.fromMap({
        'user_id': request.userId,
        'latitude': request.latitude,
        'longitude': request.longitude,
        'note': request.note,
        'photo': MultipartFile.fromBytes(
          bytes,
          filename: 'checkout_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      });

      final response = await dio.post(
        '/attendance/check-out',
        data: requestData,
      );
      return response.data;
    } on DioException catch (e) {
      debugPrint('error checkout: ${e.response?.data}');
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

  Future<AttendanceResponse> getCurrentAttendance(int userId) async {
    try {
      final response = await dio.get('/attendance/today');

      return AttendanceResponse.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('error getCurrentAttendance: ${e.response?.data}');
      rethrow; // Rethrow DioException agar ditangkap di repository
    } catch (e, stacktrace) {
      debugPrint("error: $e");
      debugPrint("stackrace: $stacktrace");
      throw Exception("Data format error: $e"); // Throw Exception biasa
    }
  }
}
