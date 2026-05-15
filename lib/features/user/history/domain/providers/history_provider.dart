import 'package:attendance_cnn_app/core/data/remote/dio_provider_network.dart';
import 'package:attendance_cnn_app/features/user/history/data/datasource/history_remote_data_source.dart';
import 'package:attendance_cnn_app/features/user/history/data/repository/history_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final historyRemoteDataSource = Provider(
  (ref) => HistoryRemoteDataSource(dio: ref.watch(dioProvider)),
);

final historyRepositoryProvider = Provider(
  (ref) => HistoryRepositoryImpl(
    historyRemoteDataSource: ref.watch(historyRemoteDataSource),
  ),
);
