import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/user/home/data/datasource/dashboard_remote_data_source.dart';
import 'package:attendance_cnn_app/features/user/home/domain/models/dashboard_users_data.dart';
import 'package:attendance_cnn_app/features/user/home/domain/repository/dashboard_user_repository.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class DashboardUserRepositoryImpl extends DashboardUserRepository {
  final DashboardRemoteDataSource dashboardRemoteDataSource;
  DashboardUserRepositoryImpl({required this.dashboardRemoteDataSource});

  @override
  Future<Either<Failure, DashboardUsersData>> getDashboardUser() async {
    try {
      final response = await dashboardRemoteDataSource.getDashboardUser();
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
