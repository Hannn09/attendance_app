import 'package:attendance_cnn_app/core/domain/models/employee_model.dart';
import 'package:attendance_cnn_app/core/domain/models/users_model.dart';
import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Users>> getProfile();

  Future<Either<Failure, void>> updateProfile(EmployeeModel request);
}
