import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/user/home/data/models/dashboard_user_response.dart';
import 'package:dio/dio.dart';

class DashboardRemoteDataSource {
  final Dio dio;

  DashboardRemoteDataSource({required this.dio});

  Future<DashboardUserResponse> getDashboardUser() async {
    try {
      final response = await dio.get('/dashboard/employee');
      return DashboardUserResponse.fromJson(response.data);
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
