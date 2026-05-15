import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CardInformationCheckin extends StatefulWidget {
  const CardInformationCheckin({super.key});

  @override
  State<CardInformationCheckin> createState() => _CardInformationCheckinState();
}

class _CardInformationCheckinState extends State<CardInformationCheckin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: whiteColor,
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
            mainAxisAlignment: .spaceBetween,
            children: [
              _buildBadge(),
              Text(
                'Thursday, 9 April 2026',
                style: regularTextStyle.copyWith(
                  color: greyColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: .center,
            children: [
              _buildTimeItem('Check In', '08:00'),
              SizedBox(width: 40),
              _buildTimeItem('Check Out', '--:--'),
              Spacer(),
              GestureDetector(
                onTap: () => context.push('/attendance'),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: primaryColor,
                  ),
                  child: Icon(
                    Icons.center_focus_weak_rounded,
                    color: whiteColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                'Work Hour',
                style: regularTextStyle.copyWith(
                  color: greyColor,
                  fontSize: 16,
                ),
              ),
              Text(
                '4h 35m',
                style: mediumTextStyle.copyWith(color: blackColor),
              ),
            ],
          ),
          SizedBox(height: 5),
          LinearProgressIndicator(
            minHeight: 8,
            value: 0.5,
            borderRadius: BorderRadius.circular(65),
            backgroundColor: Color(0xFFE0E0E0),
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge() {
    return Row(
      crossAxisAlignment: .center,
      mainAxisAlignment: .center,
      children: [
        Center(
          child: Container(
            width: 7,
            height: 7,
            margin: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: greenColor,
            ),
          ),
        ),
        Text(' Hari ini', style: mediumTextStyle.copyWith(color: blackColor)),
      ],
    );
  }

  Widget _buildTimeItem(String title, String time) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          title,
          style: regularTextStyle.copyWith(color: greyColor, fontSize: 16),
        ),
        SizedBox(height: 5),
        Text(
          time,
          style: boldTextStyle.copyWith(
            fontSize: 22,
            color: blackColor,
            letterSpacing: -0.9,
          ),
        ),
      ],
    );
  }
}
