import 'dart:async';

import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/admin/employee/domain/models/schedule_list.dart';
import 'package:attendance_cnn_app/features/admin/employee/domain/providers/schedule_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ScheduleListNotifier extends AsyncNotifier<List<ScheduleList>> {
  String? _currentDate;

  @override
  FutureOr<List<ScheduleList>> build() {
    return _fetchListSchedule();
  }

  Future<List<ScheduleList>> _fetchListSchedule([String? date]) async {
    final repository = ref.read(scheduleRepositoryProvider);

    final results = await repository.getListSchedule(date);

    return results.fold(
      (failure) => throw Failure(failure.message),
      (data) => data,
    );
  }

  Future<void> refetchWithDate(DateTime date) async {
    _currentDate = DateFormat('yyyy-MM-dd').format(date);
    state = const AsyncValue.loading();
    final result = await _fetchListSchedule(_currentDate);
    state = AsyncValue.data(result);
  }
}

final scheduleListNotifierProvider =
    AsyncNotifierProvider.autoDispose<ScheduleListNotifier, List<ScheduleList>>(
      () => ScheduleListNotifier(),
    );
