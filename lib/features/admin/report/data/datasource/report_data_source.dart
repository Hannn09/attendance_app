import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/admin/report/data/models/report_response.dart';
import 'package:dio/dio.dart';

class ReportDataSource {
  final Dio dio;

  ReportDataSource({required this.dio});

  Future<ReportResponse> getAllReport() async {
    try {
      final response = await dio.get('/attendance/reports');
      return ReportResponse.fromJson(response.data);
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
