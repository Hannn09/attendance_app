import 'package:attendance_cnn_app/features/admin/employee/presentation/providers/employee_action_notifier.dart';
import 'package:attendance_cnn_app/features/admin/employee/presentation/providers/fab_provider.dart';
import 'package:attendance_cnn_app/features/admin/employee/presentation/providers/schedule_action_notiifier.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:attendance_cnn_app/widget/loading_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainAdminScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  const MainAdminScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = navigationShell.currentIndex;
    final fabConfig = ref.watch(fabProvider);
    final actionState = ref.watch(employeeActionNotifierProvider);
    final scheduleActionState = ref.watch(scheduleActionNotifierProvider);

    return Stack(
      children: [
        Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          floatingActionButton:
              fabConfig.visible && navigationShell.currentIndex == 1
              ? FloatingActionButton(
                  elevation: 0,
                  shape: CircleBorder(),
                  onPressed: fabConfig.onPressed,
                  backgroundColor: primaryColor,
                  child: Icon(Icons.add, color: whiteColor),
                )
              : null,
          body: navigationShell,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0x0F0D0A2C),
                  blurRadius: 30,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: BottomAppBar(
              color: whiteColor,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              height: 75,
              child: Row(
                mainAxisSize: .max,
                mainAxisAlignment: .spaceBetween,
                children: [
                  Expanded(
                    child: _buildNavItems(
                      'assets/ic_home.png',
                      'Home',
                      0,
                      currentIndex,
                    ),
                  ),
                  Expanded(
                    child: _buildNavItems(
                      'assets/ic_employee.png',
                      'Employee',
                      1,
                      currentIndex,
                    ),
                  ),
                  Expanded(
                    child: _buildNavItems(
                      'assets/ic_report.png',
                      'Report',
                      2,
                      currentIndex,
                    ),
                  ),
                  Expanded(
                    child: _buildNavItems(
                      'assets/ic_profile.png',
                      'Profile',
                      3,
                      currentIndex,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (actionState.isLoading || scheduleActionState.isLoading)
          const LoadingStateWidget(),
      ],
    );
  }

  Widget _buildNavItems(
    String icon,
    String label,
    int index,
    int currentIndex,
  ) {
    final isActive = index == currentIndex;
    return GestureDetector(
      onTap: () => navigationShell.goBranch(index),

      child: Column(
        mainAxisSize: .min,
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        children: [
          Image.asset(
            icon,
            width: 24,
            color: isActive ? primaryColor : greyColor,
          ),
          Text(
            label,
            style: mediumTextStyle.copyWith(
              fontSize: 10,
              color: isActive ? primaryColor : greyColor,
            ),
          ),
        ],
      ),
    );
  }
}
