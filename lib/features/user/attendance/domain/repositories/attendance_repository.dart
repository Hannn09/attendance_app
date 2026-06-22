import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/user/attendance/domain/models/attendance_data.dart';
import 'package:attendance_cnn_app/features/user/attendance/domain/models/attendance_request.dart';
import 'package:fpdart/fpdart.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, void>> checkIn(AttendanceRequest request);
  Future<Either<Failure, void>> checkOut(AttendanceRequest request);
  Future<Either<Failure, AttendanceData?>> getTodayAttendance(int userId);
}
