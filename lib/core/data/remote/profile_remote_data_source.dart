import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/core/domain/models/profile_response.dart';
import 'package:dio/dio.dart';

class ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSource({required this.dio});

  Future<ProfileResponse> getProfile() async {
    try {
      final response = await dio.get('/me');
      return ProfileResponse.fromJson(response.data);
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
