import 'dart:async';

import 'package:attendance_cnn_app/core/domain/models/users_model.dart';
import 'package:attendance_cnn_app/features/authentication/domain/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends AsyncNotifier<Users?> {
  @override
  FutureOr<Users?> build() async {
    final authLocal = ref.read(authLocalDataSource);
    final user = await authLocal.getLoggedInUser();
    return user;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.login(email, password);
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (user) => state = AsyncValue.data(user),
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();

    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.logout();
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) => state = const AsyncValue.data(null),
    );
  }
}

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, Users?>(
  () => AuthNotifier(),
);
