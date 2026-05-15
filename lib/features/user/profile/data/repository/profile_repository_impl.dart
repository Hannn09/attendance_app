import 'package:attendance_cnn_app/core/data/remote/profile_remote_data_source.dart';
import 'package:attendance_cnn_app/core/domain/models/employee_model.dart';
import 'package:attendance_cnn_app/core/domain/models/users_model.dart';
import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/user/profile/data/datasource/profile_user_remote_data_source.dart';
import 'package:attendance_cnn_app/features/user/profile/domain/repository/profile_repository.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileRemoteDataSource dataSource;
  final ProfileUserRemoteDataSource dataSourceUser;

  ProfileRepositoryImpl({
    required this.dataSource,
    required this.dataSourceUser,
  });

  @override
  Future<Either<Failure, Users>> getProfile() async {
    try {
      final response = await dataSource.getProfile();
      return Right(response.data);
    } on DioException catch (e) {
      throw Failure(
        e.response?.data['message'] as String? ??
            'An unexpected error occurred',
      );
    } catch (e) {
      throw Failure("Data format error: $e");
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(EmployeeModel data) async {
    try {
      final response = await dataSourceUser.updateProfile(data);
      return Right(response);
    } on DioException catch (e) {
      return Left(
        Failure(
          e.response?.data['message'] as String? ??
              'An unexpected error occurred',
        ),
      );
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
