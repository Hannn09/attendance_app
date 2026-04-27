import 'package:attendance_cnn_app/features/admin/employee/models/shift_type.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';

class ScheduleEmployeeCard extends StatelessWidget {
  final String employeeName;
  final ShiftType shiftType;
  final String startTime;
  final String endTime;
  final List<int> workingDays;
  final VoidCallback onShiftTap;

  const ScheduleEmployeeCard({
    super.key,
    required this.employeeName,
    required this.shiftType,
    required this.startTime,
    required this.endTime,
    required this.workingDays,
    required this.onShiftTap,
  });

  static const List<String> dayNames = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        padding: EdgeInsetsGeometry.all(10),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: blackColor.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                _buildAvatar(),
                SizedBox(width: 12),
                Expanded(child: _buildEmployeeInfo()),
                SizedBox(width: 8),
                _buildShiftBadge(context),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: List.generate(
                7,
                (index) => Padding(
                  padding: EdgeInsets.only(right: index < 6 ? 8 : 0),
                  child: _buildDayBadge(
                    dayNames[index],
                    workingDays.contains(index + 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final initials = employeeName.isNotEmpty
        ? employeeName.split(' ').map((e) => e[0].toUpperCase()).take(2).join()
        : 'E';

    return RepaintBoundary(
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [primaryColor, Color(0xFF799DFF)]),
        ),
        child: Center(
          child: Text(
            initials,
            style: semiBoldTextStyle.copyWith(fontSize: 18, color: whiteColor),
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeInfo() {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          employeeName,
          style: semiBoldTextStyle.copyWith(fontSize: 15, color: blackColor),
        ),
        SizedBox(height: 4),
        Text(
          startTime != '-' && endTime != '-'
              ? '$startTime - $endTime'
              : 'Day Off',
          style: mediumTextStyle.copyWith(fontSize: 12, color: greyColor),
        ),
      ],
    );
  }

  Widget _buildShiftBadge(BuildContext context) {
    return GestureDetector(
      onTap: onShiftTap,
      child: Container(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: _getShiftColor().withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _getShiftColor().withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(shiftType.emoji, style: TextStyle(fontSize: 14)),
            SizedBox(width: 4),
            Text(
              shiftType.displayName,
              style: mediumTextStyle.copyWith(
                fontSize: 12,
                color: _getShiftColor(),
              ),
            ),
            SizedBox(width: 2),
            Icon(Icons.keyboard_arrow_down, size: 16, color: _getShiftColor()),
          ],
        ),
      ),
    );
  }

  Widget _buildDayBadge(String day, bool isActive) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? primaryColor : greyColor.withValues(alpha: 0.15),
        border: Border.all(
          color: isActive ? primaryColor : borderColor,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          day.substring(0, 1),
          style: mediumTextStyle.copyWith(
            fontSize: 11,
            color: isActive ? whiteColor : greyColor,
          ),
        ),
      ),
    );
  }

  Color _getShiftColor() {
    switch (shiftType) {
      case ShiftType.pagi:
        return orangeColor;
      case ShiftType.siang:
        return primaryColor;
      case ShiftType.malam:
        return Color(0xFF6B7280);
      case ShiftType.libur:
        return greyColor;
    }
  }
}
