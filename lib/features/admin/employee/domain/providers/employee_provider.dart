import 'package:attendance_cnn_app/core/data/remote/dio_provider_network.dart';
import 'package:attendance_cnn_app/features/admin/employee/data/datasource/employee_remote_data_source.dart';
import 'package:attendance_cnn_app/features/admin/employee/data/repositories/employee_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final employeeRemoteDataSource = Provider(
  (ref) => EmployeeRemoteDataSource(dio: ref.read(dioProvider)),
);

final employeeRepositoryProvider = Provider(
  (ref) =>
      EmployeeRepositoryImpl(datasource: ref.read(employeeRemoteDataSource)),
);
