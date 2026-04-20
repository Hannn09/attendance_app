import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';

class AttendanceTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const AttendanceTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .center,
      mainAxisAlignment: .center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onTabChanged(0),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: .min,
              children: [
                Text(
                  'Today',
                  textAlign: .center,
                  style: mediumTextStyle.copyWith(
                    color: selectedIndex == 0 ? primaryColor : blackColor,
                  ),
                ),
                SizedBox(height: 8),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: 3,
                  width: 40,
                  decoration: BoxDecoration(
                    color: selectedIndex == 0 ? primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: GestureDetector(
            onTap: () => onTabChanged(1),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: .min,
              children: [
                Text(
                  'Schedule',
                  textAlign: .center,
                  style: mediumTextStyle.copyWith(
                    color: selectedIndex == 1 ? primaryColor : blackColor,
                  ),
                ),
                SizedBox(height: 8),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: 3,
                  width: 40,
                  decoration: BoxDecoration(
                    color: selectedIndex == 1 ? primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
