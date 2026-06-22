import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/user/attendance/data/datasource/attendance_remote_data_source.dart';
import 'package:attendance_cnn_app/features/user/attendance/domain/models/attendance_data.dart';
import 'package:attendance_cnn_app/features/user/attendance/domain/models/attendance_request.dart';
import 'package:attendance_cnn_app/features/user/attendance/domain/repositories/attendance_repository.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class AttendanceRepositoryImpl extends AttendanceRepository {
  final AttendanceRemoteDataSource dataSource;

  AttendanceRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, void>> checkIn(AttendanceRequest request) async {
    try {
      await dataSource.checkIn(request);
      return const Right(null);
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

  @override
  Future<Either<Failure, void>> checkOut(AttendanceRequest request) async {
    try {
      await dataSource.checkOut(request);
      return const Right(null);
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

  @override
  Future<Either<Failure, AttendanceData?>> getTodayAttendance(
    int userId,
  ) async {
    try {
      final response = await dataSource.getCurrentAttendance(userId);
      return Right(response.data);
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
