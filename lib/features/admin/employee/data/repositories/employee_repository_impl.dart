import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/admin/employee/data/datasource/employee_remote_data_source.dart';
import 'package:attendance_cnn_app/features/admin/employee/data/models/employee_response.dart';
import 'package:attendance_cnn_app/core/domain/models/employee_model.dart';
import 'package:attendance_cnn_app/features/admin/employee/domain/repositories/employee_repository.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class EmployeeRepositoryImpl extends EmployeeRepository {
  final EmployeeRemoteDataSource datasource;

  EmployeeRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, EmployeeResponse>> createEmployee(
    EmployeeModel data,
  ) async {
    try {
      final response = await datasource.createEmployee(data);
      return Right(response);
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
  Future<Either<Failure, void>> deleteEmployee(int id) async {
    try {
      final response = await datasource.deleteEmployee(id);
      return Right(response);
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
  Future<Either<Failure, EmployeeResponse>> updateEmployee(
    int id,
    EmployeeModel data,
  ) async {
    try {
      final response = await datasource.updateEmployee(id, data);
      return Right(response);
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
  Future<Either<Failure, List<EmployeeModel>>> getAllEmployee() async {
    try {
      final response = await datasource.getAllEmployee();
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
