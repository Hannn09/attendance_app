import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';

class ReportListItem extends StatelessWidget {
  final Map<String, dynamic> report;

  const ReportListItem({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final String status = report['status'] as String;
    final String initials = report['initials'] as String;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border(bottom: BorderSide(color: dividerColor)),
      ),
      child: Row(
        children: [
          _buildAvatar(initials),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report['employeeName'] as String,
                  style: semiBoldTextStyle.copyWith(fontSize: 16),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _buildTimeItem(
                      Icons.login_rounded,
                      report['checkIn'] as String,
                      greenColor,
                    ),
                    SizedBox(width: 8),
                    _buildTimeItem(
                      Icons.logout_rounded,
                      report['checkOut'] as String,
                      primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildStatusBadge(status),
        ],
      ),
    );
  }

  Widget _buildAvatar(String initials) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFE3F2FD),
      ),
      child: Center(
        child: Text(
          initials,
          style: boldTextStyle.copyWith(fontSize: 16, color: Color(0xFF1976D2)),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;

    switch (status.toUpperCase()) {
      case 'ON TIME':
        badgeColor = greenColor;
        break;
      case 'LATE':
        badgeColor = orangeColor;
        break;
      case 'ABSENT':
        badgeColor = redColor;
        break;
      default:
        badgeColor = greyColor;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: badgeColor.withAlpha(20),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: mediumTextStyle.copyWith(fontSize: 12, color: badgeColor),
      ),
    );
  }

  Widget _buildTimeItem(IconData icon, String time, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 10),
        SizedBox(width: 4),
        Text(
          time,
          style: mediumTextStyle.copyWith(fontSize: 12, color: greyColor),
        ),
      ],
    );
  }
}
