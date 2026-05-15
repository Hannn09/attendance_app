import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ScheduleListItem extends StatelessWidget {
  final String employeeName;
  final String shiftType;
  final VoidCallback? onShiftTap;

  const ScheduleListItem({
    super.key,
    required this.employeeName,
    required this.shiftType,
    this.onShiftTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildAvatar(context),
          SizedBox(width: 12),
          Expanded(child: _buildEmployeeInfo()),
          SizedBox(width: 8),
          _buildShiftBadge(context),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final isSkeleton = Skeletonizer.maybeOf(context)?.enabled ?? false;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isSkeleton
            ? null
            : LinearGradient(colors: [primaryColor, Color(0xFF799DFF)]),
        color: isSkeleton ? greyColor.withOpacity(0.3) : null,
      ),
      child: Center(
        child: Text(
          employeeName.isNotEmpty ? employeeName[0].toUpperCase() : 'E',
          style: semiBoldTextStyle.copyWith(fontSize: 20, color: whiteColor),
        ),
      ),
    );
  }

  Widget _buildEmployeeInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          employeeName,
          style: semiBoldTextStyle.copyWith(fontSize: 16, color: blackColor),
        ),
        SizedBox(height: 4),
        Text(
          'Shift',
          style: mediumTextStyle.copyWith(fontSize: 12, color: greyColor),
        ),
      ],
    );
  }

  Widget _buildShiftBadge(BuildContext context) {
    final isSkeleton = Skeletonizer.maybeOf(context)?.enabled ?? false;
    final canTap = onShiftTap != null && !isSkeleton;

    final badge = Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: canTap
            ? Border.all(
                color: primaryColor.withOpacity(0.3),
                width: 1,
              )
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            shiftType,
            style: mediumTextStyle.copyWith(fontSize: 12, color: primaryColor),
          ),
          if (canTap) ...[
            SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: primaryColor,
            ),
          ],
        ],
      ),
    );

    if (canTap) {
      return GestureDetector(
        onTap: onShiftTap,
        child: badge,
      );
    }

    return badge;
  }
}
