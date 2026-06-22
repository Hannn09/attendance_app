import 'package:attendance_cnn_app/features/user/attendance/domain/models/attendance_data.dart';
import 'package:attendance_cnn_app/features/user/attendance/domain/providers/attendance_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Family provider for user-specific attendance data using FutureProvider
final attendanceDataNotifierProvider = FutureProvider.family<AttendanceData?, int>(
  (ref, userId) async {
    final result = await ref.read(attendanceRepositoryProvider).getTodayAttendance(userId);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (value) => value,
    );
  },
);
