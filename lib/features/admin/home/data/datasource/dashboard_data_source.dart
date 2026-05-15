import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/admin/home/data/model/dashboard_response.dart';
import 'package:dio/dio.dart';

class DashboardDataSource {
  final Dio dio;

  DashboardDataSource({required this.dio});

  Future<DashboardResponse> getDashboardData() async {
    try {
      final response = await dio.get('/dashboard');
      return DashboardResponse.fromJson(response.data);
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
