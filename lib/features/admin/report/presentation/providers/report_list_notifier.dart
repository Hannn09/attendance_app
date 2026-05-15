import 'dart:async';

import 'package:attendance_cnn_app/features/admin/report/domain/models/report_list.dart';
import 'package:attendance_cnn_app/features/admin/report/domain/providers/report_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportListNotifier extends AsyncNotifier<List<ReportList>> {
  @override
  FutureOr<List<ReportList>> build() {
    return _fetchReport();
  }

  Future<List<ReportList>> _fetchReport() async {
    final repository = ref.read(reportRepositoryProvider);
    final result = await repository.getAllReport();

    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  }

  Future<void> refetch() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchReport());
  }
}

final reportListNotifierProvider =
    AsyncNotifierProvider<ReportListNotifier, List<ReportList>>(
      () => ReportListNotifier(),
    );
