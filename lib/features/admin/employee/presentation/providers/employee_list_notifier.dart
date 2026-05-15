import 'dart:async';

import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/core/domain/models/employee_model.dart';
import 'package:attendance_cnn_app/features/admin/employee/domain/providers/employee_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployeeListNotifier extends AsyncNotifier<List<EmployeeModel>> {
  @override
  FutureOr<List<EmployeeModel>> build() {
    return _fetchListEmployee();
  }

  Future<List<EmployeeModel>> _fetchListEmployee() async {
    final repository = ref.read(employeeRepositoryProvider);

    final results = await repository.getAllEmployee();

    return results.fold(
      (failure) => throw Failure(failure.message),
      (data) => data,
    );
  }
}

final employeeListNotifierProvider =
    AsyncNotifierProvider.autoDispose<
      EmployeeListNotifier,
      List<EmployeeModel>
    >(() => EmployeeListNotifier());
