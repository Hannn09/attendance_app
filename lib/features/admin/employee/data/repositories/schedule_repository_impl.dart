import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/admin/employee/data/datasource/schedule_remote_data_source.dart';
import 'package:attendance_cnn_app/features/admin/employee/domain/models/schedule_list.dart';
import 'package:attendance_cnn_app/features/admin/employee/domain/models/schedule_request.dart';
import 'package:attendance_cnn_app/features/admin/employee/domain/repositories/schedule_repository.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class ScheduleRepositoryImpl extends ScheduleRepository {
  final ScheduleRemoteDataSource datasource;

  ScheduleRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, List<ScheduleList>>> getListSchedule([String? date]) async {
    try {
      final response = await datasource.getListSchedule(date);
      return Right(response.data ?? []);
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
  Future<Either<Failure, void>> upsertSchedule(
    ScheduleRequest request,
    int userId,
  ) async {
    try {
      final response = await datasource.upsertSchedule(request, userId);
      return right(response);
    } on DioException catch (e) {
      return left(
        Failure(
          e.response?.data['message'] as String? ??
              'An unexpected error occurred',
        ),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
