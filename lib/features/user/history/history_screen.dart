import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
              crossAxisAlignment: .start,
              children: [
                Text(
                  'Attendance History',
                  style: boldTextStyle.copyWith(fontSize: 18),
                ),
                SizedBox(height: 20),

                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: .stretch,
                    children: [
                      Expanded(child: _buildCardTotalAttendance(20)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          children: [
                            _buildCardInformation('Present', 10),
                            SizedBox(height: 10),
                            _buildCardInformation('Absent', 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(child: _customRadioButton('All', true, () {})),
                    SizedBox(width: 5),
                    Expanded(
                      child: _customRadioButton('Presents', false, () {}),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: _customRadioButton('Absents', false, () {}),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _buildCardListAttendance(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customRadioButton(
    String title,
    bool isSelected,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        alignment: .center,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: isSelected ? primaryColor : lightGreyColor),
        ),
        child: Text(
          title,
          style: isSelected
              ? mediumTextStyle.copyWith(color: whiteColor)
              : regularTextStyle.copyWith(color: greyColor),
        ),
      ),
    );
  }

  Widget _buildCardTotalAttendance(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
      // margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: primaryColor,
      ),
      child: Column(
        mainAxisAlignment: .spaceBetween,
        crossAxisAlignment: .start,
        children: [
          Text(
            'Total Attendance',
            style: mediumTextStyle.copyWith(color: whiteColor),
          ),
          Text(
            '$count Days',
            style: boldTextStyle.copyWith(
              fontSize: 26,
              color: whiteColor,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardInformation(String title, int count) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
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
        children: [
          Container(
            width: 35,
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '$count',
              textAlign: .center,
              style: boldTextStyle.copyWith(fontSize: 18, color: whiteColor),
            ),
          ),
          Column(
            crossAxisAlignment: .start,
            children: [
              Text(title, style: boldTextStyle.copyWith(color: blackColor)),
              Text(
                'Days',
                style: mediumTextStyle.copyWith(color: greyColor, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardListAttendance() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 8),
            blurRadius: 15,
            color: blackColor.withValues(alpha: 0.10),
          ),
        ],
        color: whiteColor,
        border: Border.all(color: dividerColor),
      ),
      child: Row(
        children: [
          _buildItemCalendar(),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                children: [
                  Text('Thursday', style: boldTextStyle.copyWith(fontSize: 16)),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: greenColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'Present',
                      style: mediumTextStyle.copyWith(
                        fontSize: 12,
                        color: greenColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  _buildIItemChecklog(Icons.login_rounded, '00.00', greenColor),
                  SizedBox(width: 10),
                  _buildIItemChecklog(
                    Icons.logout_rounded,
                    '08.00',
                    primaryColor,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemCalendar() {
    return Container(
      width: 60,
      padding: EdgeInsetsDirectional.all(10),
      decoration: BoxDecoration(
        color: greenColor.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text('19', style: boldTextStyle.copyWith(color: greenColor)),
          Text('Apr', style: mediumTextStyle.copyWith(color: greenColor)),
        ],
      ),
    );
  }

  Widget _buildIItemChecklog(IconData icon, String time, Color iconColor) {
    return Row(
      children: [
        Icon(Icons.login_rounded, color: iconColor, size: 12),
        SizedBox(width: 5),
        Text(
          '00.00',
          style: mediumTextStyle.copyWith(fontSize: 12, color: iconColor),
        ),
      ],
    );
  }
}
