import 'dart:async';

import 'package:attendance_cnn_app/core/domain/models/users_model.dart';
import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/authentication/presentation/providers/auth_notifier.dart';
import 'package:attendance_cnn_app/features/user/profile/domain/providers/profile_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileNotifier extends AsyncNotifier<Users?> {
  @override
  FutureOr<Users?> build() async {
    final authState = ref.watch(authNotifierProvider);

    if (authState.isLoading || authState.value == null) {
      return null;
    }

    return getProfile();
  }

  Future<Users> getProfile() async {
    final result = await ref.read(profileRepository).getProfile();
    return result.fold(
      (failure) => throw Failure(failure.message),
      (profileData) => profileData,
    );
  }

  Future<void> refetch() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => getProfile());
  }
}

final profileNotifierProvider = AsyncNotifierProvider<ProfileNotifier, Users?>(
  () => ProfileNotifier(),
);
