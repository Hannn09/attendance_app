import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';

class TodayTabContent extends StatelessWidget {
  const TodayTabContent({super.key});

  @override
  Widget build(BuildContext context) {
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
            Expanded(child: _buildCardTodayContent()),
            SizedBox(width: 10),
            Expanded(child: _buildCardTodayContent()),
          ],
        ),
      ],
    );
  }

  Widget _buildCardTodayContent() {
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
            '0m',
            style: boldTextStyle.copyWith(fontSize: 22, color: primaryColor),
          ),
        ],
      ),
    );
  }
}
