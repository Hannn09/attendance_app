import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/user/history/data/datasource/history_remote_data_source.dart';
import 'package:attendance_cnn_app/features/user/history/domain/models/history_data.dart';
import 'package:attendance_cnn_app/features/user/history/domain/repository/history_repository.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class HistoryRepositoryImpl extends HistoryRepository {
  final HistoryRemoteDataSource historyRemoteDataSource;

  HistoryRepositoryImpl({required this.historyRemoteDataSource});

  @override
  Future<Either<Failure, List<History>>> getHistory() async {
    try {
      final response = await historyRemoteDataSource.getHistory();
      return Right(response.data);
    } on DioException catch (e) {
      return Left(
        Failure(
          e.response?.data['message'] as String? ??
              'An unexpected error occurred',
        ),
      );
    } catch (e) {
      return Left(Failure("Data format error: $e"));
    }
  }
}
