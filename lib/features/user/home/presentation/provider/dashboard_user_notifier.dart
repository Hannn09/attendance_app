import 'dart:async';

import 'package:attendance_cnn_app/features/authentication/presentation/providers/auth_notifier.dart';
import 'package:attendance_cnn_app/features/user/home/domain/models/dashboard_users_data.dart';
import 'package:attendance_cnn_app/features/user/home/domain/providers/dashboard_user_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardUserNotifier extends AsyncNotifier<DashboardUsersData> {
  @override
  FutureOr<DashboardUsersData> build() {
    final authState = ref.watch(authNotifierProvider);
    if (authState.isLoading || authState.value == null) {
      return Future.error("User not found", StackTrace.current);
    }
    return fetchDashboardUser();
  }

  Future<DashboardUsersData> fetchDashboardUser() async {
    final repository = ref.read(dashboardUserRepositoryProvider);
    final result = await repository.getDashboardUser();

    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  }

  Future<void> refetch() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchDashboardUser());
  }
}

final dashboardUserNotifierProvider =
    AsyncNotifierProvider<DashboardUserNotifier, DashboardUsersData>(
      () => DashboardUserNotifier(),
    );
