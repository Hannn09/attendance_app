import 'package:attendance_cnn_app/features/admin/report/domain/models/report_list.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReportListItem extends StatelessWidget {
  final ReportList report;

  const ReportListItem({super.key, required this.report});

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return '--:--';

    try {
      final dateTime = DateTime.parse(time);
      // Add 7 hours for UTC to WIB conversion
      final wibTime = dateTime.add(Duration(hours: 7));
      final hour = wibTime.hour.toString().padLeft(2, '0');
      final minute = wibTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } catch (e) {
      return '--:--';
    }
  }

  // Map status from backend to display
  String _mapStatus(String? status) {
    if (status == null) return 'Absent';

    switch (status.toLowerCase()) {
      case 'hadir':
        return 'On Time';
      case 'telat':
        return 'Late';
      case 'absent':
        return 'Absent';
      default:
        return 'Absent';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ON TIME':
        return greenColor;
      case 'LATE':
        return orangeColor;
      case 'ABSENT':
        return redColor;
      default:
        return greyColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSkeleton = Skeletonizer.maybeOf(context)?.enabled ?? false;
    final displayName = report.name ?? 'Unknown';
    final initials = isSkeleton
        ? '??'
        : (displayName.isNotEmpty ? displayName[0].toUpperCase() : '?');
    final status = _mapStatus(report.status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border(bottom: BorderSide(color: dividerColor)),
      ),
      child: Row(
        children: [
          _buildAvatar(initials, isSkeleton),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: semiBoldTextStyle.copyWith(fontSize: 16),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _buildTimeItem(
                      Icons.login_rounded,
                      _formatTime(report.checkInTime),
                      greenColor,
                    ),
                    SizedBox(width: 8),
                    _buildTimeItem(
                      Icons.logout_rounded,
                      _formatTime(report.checkOutTime),
                      primaryColor,
                    ),
                  ],
                ),
                if (report.checkInLatitude != null ||
                    report.checkInLongitude != null ||
                    report.checkOutLatitude != null ||
                    report.checkOutLongitude != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (report.checkInLatitude != null ||
                            report.checkInLongitude != null)
                          _buildLocationItem(
                            Icons.location_on_rounded,
                            greenColor,
                            report.checkInLatitude.toString(),
                            report.checkInLongitude.toString(),
                          ),
                        if (report.checkOutLatitude != null ||
                            report.checkOutLongitude != null)
                          Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: _buildLocationItem(
                              Icons.location_on_rounded,
                              primaryColor,
                              report.checkOutLatitude.toString(),
                              report.checkOutLongitude.toString(),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          _buildStatusBadge(status),
        ],
      ),
    );
  }

  Widget _buildAvatar(String initials, bool isSkeleton) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSkeleton ? greyColor.withOpacity(0.3) : Color(0xFFE3F2FD),
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
    final badgeColor = _getStatusColor(status);

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

  Widget _buildLocationItem(
    IconData icon,
    Color color,
    String? latitude,
    String? longitude,
  ) {
    final locationText = _formatLocation(latitude, longitude);

    return Row(
      children: [
        Icon(icon, color: color, size: 10),
        SizedBox(width: 4),
        Flexible(
          child: Text(
            locationText,
            style: mediumTextStyle.copyWith(fontSize: 11, color: greyColor),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatLocation(String? latitude, String? longitude) {
    if (latitude == null && longitude == null) return '';

    final lat = latitude ?? 'N/A';
    final lng = longitude ?? 'N/A';
    return 'Lat: $lat, Lng: $lng';
  }
}
