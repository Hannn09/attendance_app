import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/user/home/domain/models/dashboard_users_data.dart';
import 'package:fpdart/fpdart.dart';

abstract class DashboardUserRepository {
  Future<Either<Failure, DashboardUsersData>> getDashboardUser();
}
