import 'package:attendance_cnn_app/core/data/remote/dio_provider_network.dart';
import 'package:attendance_cnn_app/features/user/home/data/datasource/dashboard_remote_data_source.dart';
import 'package:attendance_cnn_app/features/user/home/data/repositories/dashboard_user_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardRemoteDataSourceProvider = Provider(
  (ref) => DashboardRemoteDataSource(dio: ref.watch(dioProvider)),
);

final dashboardUserRepositoryProvider = Provider(
  (ref) => DashboardUserRepositoryImpl(
    dashboardRemoteDataSource: ref.watch(dashboardRemoteDataSourceProvider),
  ),
);
