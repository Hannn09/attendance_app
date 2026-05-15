import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/admin/employee/data/models/schedules_response.dart';
import 'package:attendance_cnn_app/features/admin/employee/domain/models/schedule_request.dart';
import 'package:dio/dio.dart';

class ScheduleRemoteDataSource {
  final Dio dio;

  ScheduleRemoteDataSource({required this.dio});

  Future<SchedulesResponse> getListSchedule([String? date]) async {
    try {
      final response = await dio.get(
        '/schedules',
        queryParameters: date != null ? {'date': date} : null,
      );
      return SchedulesResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Failure(
        e.response?.data['message'] as String? ??
            'An unexpected error occurred',
      );
    } catch (e) {
      throw Failure("Data format error: $e");
    }
  }

  Future<void> upsertSchedule(ScheduleRequest request, int userId) async {
    try {
      final response = await dio.put(
        '/schedules/$userId/date',
        data: request.toJson(),
      );
      return response.data;
    } on DioException catch (e) {
      throw Failure(
        e.response?.data['message'] as String? ??
            'An unexpected error occurred',
      );
    } catch (e) {
      throw Failure("Data format error: $e");
    }
  }
}
