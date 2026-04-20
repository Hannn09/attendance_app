import 'package:attendance_cnn_app/features/admin/home/widgets/card_dashboard.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';

class HomeAdminScreen extends StatefulWidget {
  const HomeAdminScreen({super.key});

  @override
  State<HomeAdminScreen> createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: .start,
              children: [_buildHeader(), SizedBox(height: 35), CardDashboard()],
            ),
          ),
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
                'Admin',
                style: mediumTextStyle.copyWith(fontSize: 12, color: greyColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
