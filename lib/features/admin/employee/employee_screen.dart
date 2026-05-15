import 'package:attendance_cnn_app/features/admin/employee/presentation/providers/fab_provider.dart';
import 'package:attendance_cnn_app/features/admin/employee/presentation/widgets/employee_list_tab_content.dart';
import 'package:attendance_cnn_app/features/admin/employee/presentation/widgets/employee_tab_bar.dart';
import 'package:attendance_cnn_app/features/admin/employee/presentation/widgets/schedule_tab_content.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen>
    with WidgetsBindingObserver {
  int _selectedTabIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_selectedTabIndex == 0) {
            ref
                .read(fabProvider.notifier)
                .show(() => context.push('/add-employee'));
          } else {
            ref.read(fabProvider.notifier).hide();
          }
        });

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
      },
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
