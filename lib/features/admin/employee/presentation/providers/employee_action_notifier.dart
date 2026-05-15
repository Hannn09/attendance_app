import 'dart:async';

import 'package:attendance_cnn_app/features/admin/employee/data/models/employee_response.dart';
import 'package:attendance_cnn_app/core/domain/models/employee_model.dart';
import 'package:attendance_cnn_app/features/admin/employee/domain/providers/employee_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployeeActionNotifier extends AsyncNotifier<EmployeeResponse?> {
  @override
  FutureOr<EmployeeResponse?> build() {
    return null;
  }

  Future<void> createEmployee(EmployeeModel data) async {
    state = AsyncValue.loading();

    final employeeRepository = ref.read(employeeRepositoryProvider);
    final result = await employeeRepository.createEmployee(data);

    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (response) => AsyncValue.data(response),
    );
  }

  Future<void> updateEmployee(int id, EmployeeModel data) async {
    state = AsyncValue.loading();

    final employeeRepository = ref.read(employeeRepositoryProvider);
    final result = await employeeRepository.updateEmployee(id, data);

    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (response) => AsyncValue.data(response),
    );
  }

  Future<void> deleteEmployee(int id) async {
    state = AsyncValue.loading();

    final employeeRepository = ref.read(employeeRepositoryProvider);
    final result = await employeeRepository.deleteEmployee(id);

    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (response) => AsyncValue.data(null),
    );
  }

  void reset() {
    state = AsyncValue.data(null);
  }
}

final employeeActionNotifierProvider =
    AsyncNotifierProvider<EmployeeActionNotifier, EmployeeResponse?>(
      EmployeeActionNotifier.new,
    );
