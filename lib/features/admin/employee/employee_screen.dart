import 'package:attendance_cnn_app/features/admin/employee/widgets/employee_list_tab_content.dart';
import 'package:attendance_cnn_app/features/admin/employee/widgets/employee_tab_bar.dart';
import 'package:attendance_cnn_app/features/admin/employee/widgets/schedule_tab_content.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.all(25),
            child: Column(
              children: [
                EmployeeTabBar(
                  selectedIndex: _selectedTabIndex,
                  onTabChanged: (index) =>
                      setState(() => _selectedTabIndex = index),
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

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return EmployeeListTabContent();
      case 1:
        return ScheduleTabContent();
      default:
        return EmployeeListTabContent();
    }
  }
}
