import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/admin/employee/domain/models/schedule_list.dart';
import 'package:attendance_cnn_app/features/admin/employee/domain/models/schedule_request.dart';
import 'package:fpdart/fpdart.dart';

abstract class ScheduleRepository {
  Future<Either<Failure, List<ScheduleList>>> getListSchedule([String? date]);
  Future<Either<Failure, void>> upsertSchedule(
    ScheduleRequest request,
    int userId,
  );
}
