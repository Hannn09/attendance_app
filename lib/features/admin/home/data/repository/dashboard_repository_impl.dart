import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/admin/home/data/datasource/dashboard_data_source.dart';
import 'package:attendance_cnn_app/features/admin/home/domain/models/dashboard_data.dart';
import 'package:attendance_cnn_app/features/admin/home/domain/repository/dashboard_repository.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class DashboardRepositoryImpl extends DashboardRepository {
  final DashboardDataSource dashboardDataSource;

  DashboardRepositoryImpl({required this.dashboardDataSource});

  @override
  Future<Either<Failure, DashboardData>> getDashboardData() async {
    try {
      final response = await dashboardDataSource.getDashboardData();
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
