import 'package:attendance_cnn_app/core/data/remote/dio_provider_network.dart';
import 'package:attendance_cnn_app/features/user/attendance/data/datasource/attendance_remote_data_source.dart';
import 'package:attendance_cnn_app/features/user/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final attendanceRemoteDataSourceProvider = Provider((ref) {
  return AttendanceRemoteDataSource(dio: ref.watch(dioProvider));
});

final attendanceRepositoryProvider = Provider((ref) {
  return AttendanceRepositoryImpl(
    dataSource: ref.watch(attendanceRemoteDataSourceProvider),
  );
});
