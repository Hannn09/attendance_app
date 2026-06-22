import 'dart:async';

import 'package:attendance_cnn_app/features/admin/home/domain/models/dashboard_data.dart';
import 'package:attendance_cnn_app/features/admin/home/domain/providers/dashboard_providers.dart';
import 'package:attendance_cnn_app/features/authentication/presentation/providers/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardNotifier extends AsyncNotifier<DashboardData> {
  @override
  FutureOr<DashboardData> build() {
    final authState = ref.watch(authNotifierProvider);
    if (authState.isLoading || authState.value == null) {
      return Future.error("User not found", StackTrace.current);
    }
    return _fetchDashboard();
  }

  Future<DashboardData> _fetchDashboard() async {
    final repository = ref.read(dashboardRepositoryProvider);
    final result = await repository.getDashboardData();

    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  }

  Future<void> refetch() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchDashboard());
  }
}

final dashboardNotifierProvider =
    AsyncNotifierProvider<DashboardNotifier, DashboardData>(
      () => DashboardNotifier(),
    );
