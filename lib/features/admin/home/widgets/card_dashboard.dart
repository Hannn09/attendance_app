import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';

class CardDashboard extends StatelessWidget {
  const CardDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildCardEmployee()),
            SizedBox(width: 15),
            Expanded(
              child: _buildStatCard(
                title: 'Present\nToday',
                count: '120',
                icon: Icons.calendar_today_outlined,
                iconColor: greenColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Late',
                count: '15',
                icon: Icons.warning_amber_rounded,
                iconColor: orangeColor,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: _buildStatCard(
                title: 'Absent',
                count: '15',
                icon: Icons.access_time,
                iconColor: redColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardEmployee() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dividerColor),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            crossAxisAlignment: .center,
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                'Total\nEmployees',
                style: mediumTextStyle.copyWith(color: greyColor),
              ),
              Icon(Icons.people_alt_outlined, color: primaryColor, size: 18),
            ],
          ),
          SizedBox(height: 10),
          Text(
            '150',
            style: boldTextStyle.copyWith(color: primaryColor, fontSize: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String count,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            offset: Offset(0, 1),
            color: blackColor.withAlpha(5),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dividerColor),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            crossAxisAlignment: .center,
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(title, style: mediumTextStyle.copyWith(color: blackColor)),
              Icon(icon, color: iconColor, size: 18),
            ],
          ),
          SizedBox(height: 10),
          Text(
            count,
            style: boldTextStyle.copyWith(color: blackColor, fontSize: 30),
          ),
        ],
      ),
    );
  }
}
