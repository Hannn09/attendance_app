import 'package:attendance_cnn_app/features/user/attendance/domain/models/attendance_data.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';

class TodayTabContent extends StatelessWidget {
  final AttendanceData? attendance;

  const TodayTabContent({
    super.key,
    this.attendance,
  });

  @override
  Widget build(BuildContext context) {
    final workDuration = _calculateWorkDuration(
      attendance?.checkInTime,
      attendance?.checkOutTime,
    );
    final overtimeDuration = _calculateOvertimeDuration(workDuration);

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          textAlign: .center,
          'Status',
          style: boldTextStyle.copyWith(color: blackColor, fontSize: 16),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildWorkHourCard(workDuration),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _buildOvertimeCard(overtimeDuration),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWorkHourCard(String duration) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
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
            children: [
              Icon(Icons.access_time, color: primaryColor, size: 20),
              SizedBox(width: 10),
              Text(
                'Jam Kerja',
                style: mediumTextStyle.copyWith(color: greyColor),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            duration,
            style: boldTextStyle.copyWith(fontSize: 22, color: primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildOvertimeCard(String duration) {
    final hasOvertime = !duration.contains('0m');
    final overtimeColor = hasOvertime ? Color(0xFFFF6B6B) : greyColor;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
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
            children: [
              Icon(
                hasOvertime ? Icons.timer_outlined : Icons.history_toggle_off,
                color: overtimeColor,
                size: 20,
              ),
              SizedBox(width: 10),
              Text(
                'Jam Lembur',
                style: mediumTextStyle.copyWith(color: greyColor),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            duration,
            style: boldTextStyle.copyWith(fontSize: 22, color: overtimeColor),
          ),
        ],
      ),
    );
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

  String _calculateOvertimeDuration(String workDuration) {
    final parts = workDuration.split(' ');
    if (parts.length >= 2) {
      try {
        final hours = double.parse(parts[0].replaceAll('h', ''));
        final minutes = double.parse(parts[1].replaceAll('m', ''));
        final totalMinutes = hours * 60 + minutes;
        final workDayMinutes = 8 * 60; // 8 hour work day

        if (totalMinutes > workDayMinutes) {
          final overtimeMinutes = totalMinutes - workDayMinutes;
          final overtimeHours = overtimeMinutes ~/ 60;
          final remainingMinutes = (overtimeMinutes % 60).toInt();
          return '${overtimeHours}h ${remainingMinutes}m';
        }
        return '0m';
      } catch (e) {
        return '0m';
      }
    }
    return '0m';
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
}
