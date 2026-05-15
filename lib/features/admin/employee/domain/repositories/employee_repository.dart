import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/admin/employee/data/models/employee_response.dart';
import 'package:attendance_cnn_app/core/domain/models/employee_model.dart';
import 'package:fpdart/fpdart.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, EmployeeResponse>> createEmployee(EmployeeModel data);
  Future<Either<Failure, EmployeeResponse>> updateEmployee(
    int id,
    EmployeeModel data,
  );
  Future<Either<Failure, void>> deleteEmployee(int id);
  Future<Either<Failure, List<EmployeeModel>>> getAllEmployee();
}
