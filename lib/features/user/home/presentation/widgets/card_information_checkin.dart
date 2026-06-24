import 'package:attendance_cnn_app/core/domain/models/users_model.dart';
import 'package:attendance_cnn_app/features/user/attendance/domain/models/attendance_data.dart';
import 'package:attendance_cnn_app/features/user/attendance/presentation/providers/attendance_data_notifier.dart';
import 'package:attendance_cnn_app/features/user/profile/presentation/providers/profile_notifier.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CardInformationCheckin extends ConsumerWidget {
  const CardInformationCheckin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileNotifierProvider);

    return profileAsync.when(
      data: (profile) {
        if (profile == null) {
          return _buildContent(context, ref, null, null);
        }
        final attendanceAsync = ref.watch(
          attendanceDataNotifierProvider(profile.id),
        );
        return attendanceAsync.when(
          data: (attendance) =>
              _buildContent(context, ref, attendance, profile),
          loading: () => _buildLoadingContent(),
          error: (_, _) => _buildContent(context, ref, null, profile),
        );
      },
      loading: () => _buildLoadingContent(),
      error: (_, _) => _buildContent(context, ref, null, null),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    AttendanceData? attendance,
    Users? profile,
  ) {
    final checkInTime = _formatTime(attendance?.checkInTime);
    final checkOutTime = _formatTime(attendance?.checkOutTime);
    final workDuration = _calculateWorkDuration(
      attendance?.checkInTime,
      attendance?.checkOutTime,
    );
    final workProgress = _calculateWorkProgress(workDuration);

    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 8),
            blurRadius: 15,
            color: blackColor.withValues(alpha: 0.10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            crossAxisAlignment: .center,
            mainAxisAlignment: .spaceBetween,
            children: [
              _buildBadge(attendance?.status),
              Text(
                _getCurrentDate(),
                style: regularTextStyle.copyWith(
                  color: greyColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: .center,
            children: [
              _buildTimeItem('Check In', checkInTime ?? '--:--'),
              SizedBox(width: 40),
              _buildTimeItem('Check Out', checkOutTime ?? '--:--'),
              Spacer(),
              GestureDetector(
                onTap: () {
                  if (profile != null && profile.faceEmbedding != null) {
                    context.push(
                      '/attendance',
                      extra: {
                        'userId': profile.id,
                        'faceEmbedding': profile.faceEmbedding!,
                      },
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: primaryColor,
                  ),
                  child: Icon(
                    Icons.center_focus_weak_rounded,
                    color: whiteColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                'Work Hour',
                style: regularTextStyle.copyWith(
                  color: greyColor,
                  fontSize: 16,
                ),
              ),
              Text(
                workDuration,
                style: mediumTextStyle.copyWith(color: blackColor),
              ),
            ],
          ),
          SizedBox(height: 5),
          LinearProgressIndicator(
            minHeight: 8,
            value: workProgress,
            borderRadius: BorderRadius.circular(65),
            backgroundColor: Color(0xFFE0E0E0),
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 8),
            blurRadius: 15,
            color: blackColor.withValues(alpha: 0.10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            crossAxisAlignment: .center,
            mainAxisAlignment: .spaceBetween,
            children: [
              _buildBadge(null),
              Container(
                width: 120,
                height: 14,
                decoration: BoxDecoration(
                  color: greyColor.withAlpha(50),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: .center,
            children: [
              _buildTimeItemShimmer(),
              SizedBox(width: 40),
              _buildTimeItemShimmer(),
              Spacer(),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: greyColor.withAlpha(50),
                ),
                child: Icon(Icons.center_focus_weak_rounded, color: greyColor),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 8,
            decoration: BoxDecoration(
              color: greyColor.withAlpha(50),
              borderRadius: BorderRadius.circular(65),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeItemShimmer() {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Container(
          width: 60,
          height: 14,
          decoration: BoxDecoration(
            color: greyColor.withAlpha(50),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: 80,
          height: 22,
          decoration: BoxDecoration(
            color: greyColor.withAlpha(50),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String? status) {
    final statusColor = status == 'present' ? greenColor : greyColor;
    return Row(
      crossAxisAlignment: .center,
      mainAxisAlignment: .center,
      children: [
        Center(
          child: Container(
            width: 7,
            height: 7,
            margin: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor,
            ),
          ),
        ),
        Text(' Hari ini', style: mediumTextStyle.copyWith(color: blackColor)),
      ],
    );
  }

  Widget _buildTimeItem(String title, String time) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          title,
          style: regularTextStyle.copyWith(color: greyColor, fontSize: 16),
        ),
        SizedBox(height: 5),
        Text(
          time,
          style: boldTextStyle.copyWith(
            fontSize: 22,
            color: blackColor,
            letterSpacing: -0.9,
          ),
        ),
      ],
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(now);
  }

  String? _formatTime(String? time) {
    if (time == null) return null;
    final parts = time.split(':');
    if (parts.length >= 2) {
      try {
        int hour = int.parse(parts[0]);
        final minute = parts[1];

        // Add 7 hours for UTC conversion (WIB = UTC+7)
        hour = (hour + 7) % 24;

        return '${hour.toString().padLeft(2, '0')}:$minute';
      } catch (e) {
        return time;
      }
    }
    return time;
  }

  String _calculateWorkDuration(String? checkIn, String? checkOut) {
    if (checkIn == null || checkOut == null) {
      return '0h 0m';
    }
    try {
      final now = DateTime.now();
      final inTime = _parseTime(checkIn, now);
      final outTime = _parseTime(checkOut, now);
      final duration = outTime.difference(inTime);
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      return '${hours}h ${minutes}m';
    } catch (e) {
      return '0h 0m';
    }
  }

  DateTime _parseTime(String time, DateTime now) {
    final parts = time.split(':');
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  double _calculateWorkProgress(String workDuration) {
    final parts = workDuration.split(' ');
    if (parts.length >= 2) {
      try {
        final hours = double.parse(parts[0].replaceAll('h', ''));
        final minutes = double.parse(parts[1].replaceAll('m', ''));
        final totalMinutes = hours * 60 + minutes;
        final workDayMinutes = 8 * 60; // 8 hour work day
        return (totalMinutes / workDayMinutes).clamp(0.0, 1.0);
      } catch (e) {
        return 0.0;
      }
    }
    return 0.0;
  }
}
