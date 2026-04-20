import 'package:attendance_cnn_app/features/user/home/widgets/card_information_checkin.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsGeometry.all(25),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    _buildHeader(),
                    SizedBox(height: 35),
                    CardInformationCheckin(),
                    SizedBox(height: 25),
                    Text(
                      'Summary This Month',
                      style: boldTextStyle.copyWith(fontSize: 16),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCardSummary(
                            'Present',
                            '20 Days',
                            Icons.calendar_today_outlined,
                            greenColor,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _buildCardSummary(
                            'Absent',
                            '5 Days',
                            Icons.access_time,
                            redColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCardSummary(
                            'Overtime',
                            '3 Hours',
                            Icons.more_time_sharp,
                            primaryColor,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _buildCardSummary(
                            'Late',
                            '3 Hours',
                            Icons.warning_amber_rounded,
                            orangeColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Image.asset('assets/dummy_profile.png', width: 40),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                'Muhammad Sumbul',
                style: boldTextStyle.copyWith(fontSize: 16),
              ),
              Text(
                'Employee',
                style: mediumTextStyle.copyWith(fontSize: 12, color: greyColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardSummary(
    String title,
    String content,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 8),
            blurRadius: 15,
            color: blackColor.withValues(alpha: 0.10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: .center,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: iconColor.withAlpha(50),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          Column(
            crossAxisAlignment: .start,
            children: [
              Text(title, style: mediumTextStyle.copyWith(color: greyColor)),
              Text(
                content,
                style: boldTextStyle.copyWith(color: blackColor, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
