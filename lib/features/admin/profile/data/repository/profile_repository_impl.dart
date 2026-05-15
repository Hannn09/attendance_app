import 'package:attendance_cnn_app/core/domain/models/users_model.dart';
import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/core/data/remote/profile_remote_data_source.dart';
import 'package:attendance_cnn_app/features/admin/profile/domain/repository/profile_repository.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileRemoteDataSource profileRemoteDataSource;

  ProfileRepositoryImpl({required this.profileRemoteDataSource});

  @override
  Future<Either<Failure, Users>> getProfile() async {
    try {
      final response = await profileRemoteDataSource.getProfile();
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
