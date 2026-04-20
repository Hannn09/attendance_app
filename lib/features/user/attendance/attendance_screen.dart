import 'package:attendance_cnn_app/features/user/attendance/widgets/attendance_tab_bar.dart';
import 'package:attendance_cnn_app/features/user/attendance/widgets/schedule_tab_content.dart';
import 'package:attendance_cnn_app/features/user/attendance/widgets/today_tab_content.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.all(25),
            child: Column(
              crossAxisAlignment: .center,
              children: [
                Row(
                  crossAxisAlignment: .center,
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: 24,
                        color: blackColor,
                      ),
                    ),
                    SizedBox(width: 15),
                    Text(
                      'Attendance Screen',
                      style: boldTextStyle.copyWith(
                        // fontSize: 16,
                        color: blackColor,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 55),
                Text(
                  'Kamis, 9 April 2026',
                  style: mediumTextStyle.copyWith(
                    fontSize: 16,
                    color: blackColor,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '10:10:10',
                  style: boldTextStyle.copyWith(
                    fontSize: 28,
                    color: blackColor,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .center,
                  children: [
                    _buildCardTime(),
                    _buildButtonAttendance(),
                    _buildCardTime(),
                  ],
                ),
                SizedBox(height: 35),
                AttendanceTabBar(
                  selectedIndex: _selectedTabIndex,
                  onTabChanged: (index) {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                ),
                SizedBox(height: 35),
                _buildTabContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardTime() {
    return Column(
      crossAxisAlignment: .center,
      children: [
        Text('Check In', style: mediumTextStyle.copyWith(color: greyColor)),
        Container(
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: primaryColor.withAlpha(20),
            borderRadius: BorderRadius.circular(7),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            '08:00',
            style: boldTextStyle.copyWith(
              color: primaryColor,
              fontSize: 18,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return TodayTabContent();
      case 1:
        return ScheduleTabContent();
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildButtonAttendance() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        shape: .circle,
        // borderRadius: BorderRadius.circular(100),
        gradient: LinearGradient(
          colors: [primaryColor, Color(0xFF799DFF)],
          begin: .topCenter,
          end: .bottomCenter,
          stops: [0.0, 1.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: .center,
        children: [
          Icon(Icons.logout, size: 35, color: whiteColor),
          SizedBox(height: 5),
          Text(
            'Check In',
            style: boldTextStyle.copyWith(fontSize: 16, color: whiteColor),
          ),
        ],
      ),
    );
  }
}
