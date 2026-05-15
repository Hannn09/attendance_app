import 'dart:async';

import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/features/user/history/domain/models/history_data.dart';
import 'package:attendance_cnn_app/features/user/history/domain/providers/history_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryListNotifier extends AsyncNotifier<List<History>> {
  @override
  FutureOr<List<History>> build() {
    return _fetchHistory();
  }

  Future<List<History>> _fetchHistory() async {
    final repository = ref.read(historyRepositoryProvider);
    final result = await repository.getHistory();

    return result.fold(
      (failure) => throw Failure(failure.message),
      (data) => data,
    );
  }

  Future<void> refetch() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchHistory());
  }
}

final historyListProvider =
    AsyncNotifierProvider<HistoryListNotifier, List<History>>(
      () => HistoryListNotifier(),
    );
