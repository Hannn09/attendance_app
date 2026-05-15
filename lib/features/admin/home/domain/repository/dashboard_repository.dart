import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/admin/home/domain/models/dashboard_data.dart';
import 'package:fpdart/fpdart.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardData>> getDashboardData();
}
