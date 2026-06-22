import 'dart:async';

import 'package:attendance_cnn_app/features/user/attendance/domain/models/attendance_request.dart';
import 'package:attendance_cnn_app/features/user/attendance/domain/providers/attendance_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttendanceNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> checkIn(AttendanceRequest request) async {
    state = const AsyncLoading();
    final result = await ref
        .read(attendanceRepositoryProvider)
        .checkIn(request);
    result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
      },
      (success) {
        state = const AsyncData(null);
      },
    );
  }

  Future<void> checkOut(AttendanceRequest request) async {
    state = const AsyncLoading();
    final result = await ref
        .read(attendanceRepositoryProvider)
        .checkOut(request);
    result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
      },
      (success) {
        state = const AsyncData(null);
      },
    );
  }
}

final attendanceNotifierProvider =
    AsyncNotifierProvider<AttendanceNotifier, void>(AttendanceNotifier.new);
