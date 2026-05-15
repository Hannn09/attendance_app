import 'package:attendance_cnn_app/core/data/remote/dio_provider_network.dart';
import 'package:attendance_cnn_app/features/admin/employee/data/datasource/schedule_remote_data_source.dart';
import 'package:attendance_cnn_app/features/admin/employee/data/repositories/schedule_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scheduleRemoteDataSource = Provider(
  (ref) => ScheduleRemoteDataSource(dio: ref.read(dioProvider)),
);

final scheduleRepositoryProvider = Provider(
  (ref) =>
      ScheduleRepositoryImpl(datasource: ref.read(scheduleRemoteDataSource)),
);
