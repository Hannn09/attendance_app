import 'dart:async';

import 'package:attendance_cnn_app/core/domain/models/employee_model.dart';
import 'package:attendance_cnn_app/features/user/profile/domain/providers/profile_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileActionNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> updateProfile(EmployeeModel data) async {
    state = const AsyncLoading();
    final result = await ref.read(profileRepository).updateProfile(data);
    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (_) => AsyncValue.data(null),
    );
  }
}

final profileActionNotifierProvider =
    AsyncNotifierProvider<ProfileActionNotifier, void>(
      () => ProfileActionNotifier(),
    );
