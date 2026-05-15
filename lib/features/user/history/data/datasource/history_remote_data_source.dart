import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/user/history/data/models/history_response.dart';
import 'package:dio/dio.dart';

class HistoryRemoteDataSource {
  final Dio dio;

  HistoryRemoteDataSource({required this.dio});

  Future<HistoryResponse> getHistory() async {
    try {
      final response = await dio.get('/attendance/history');
      return HistoryResponse.fromJson(response.data);
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
