import 'package:attendance_cnn_app/core/data/local/auth_local_data_source.dart';
import 'package:attendance_cnn_app/core/domain/models/users_model.dart';
import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/authentication/data/datasource/auth_remote_data_source.dart';
import 'package:attendance_cnn_app/features/authentication/data/models/auth_response.dart';
import 'package:attendance_cnn_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource dataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.dataSource, required this.localDataSource});

  @override
  Future<Either<Failure, Users>> login(String email, String password) async {
    try {
      final AuthResponse response = await dataSource.login(email, password);

      // Cache user data locally
      await localDataSource.cacheUserLoggedin(
        response.token,
        response.user.id,
        response.user,
      );

      return Right(response.user);
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] as String? ??
          'An unexpected error occurred';
      return Left(Failure(message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await dataSource.logout();
      await localDataSource.clearUserLoggedin();
      return Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
