import 'dart:async';

import 'package:attendance_cnn_app/features/admin/employee/domain/models/schedule_request.dart';
import 'package:attendance_cnn_app/features/admin/employee/domain/providers/schedule_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleActionNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> upsertSchedule(ScheduleRequest request, int userId) async {
    state = AsyncValue.loading();

    final scheduleRepository = ref.read(scheduleRepositoryProvider);

    final result = await scheduleRepository.upsertSchedule(request, userId);

    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (r) {
        state = AsyncValue.data(r);
      },
    );
  }
}

final scheduleActionNotifierProvider =
    AsyncNotifierProvider<ScheduleActionNotifier, void>(
      () => ScheduleActionNotifier(),
    );
