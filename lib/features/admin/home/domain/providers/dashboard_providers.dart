import 'package:attendance_cnn_app/core/data/remote/dio_provider_network.dart';
import 'package:attendance_cnn_app/features/admin/home/data/datasource/dashboard_data_source.dart';
import 'package:attendance_cnn_app/features/admin/home/data/repository/dashboard_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardRemoteDataSourceProvider = Provider(
  (ref) => DashboardDataSource(dio: ref.watch(dioProvider)),
);

final dashboardRepositoryProvider = Provider(
  (ref) => DashboardRepositoryImpl(
    dashboardDataSource: ref.watch(dashboardRemoteDataSourceProvider),
  ),
);
