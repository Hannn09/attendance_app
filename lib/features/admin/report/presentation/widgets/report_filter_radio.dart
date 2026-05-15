import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';

class ReportFilterRadio extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onFilterChanged;

  const ReportFilterRadio({
    super.key,
    required this.selectedIndex,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildRadioOption('All', selectedIndex == 0, () => onFilterChanged(0))),
        SizedBox(width: 5),
        Expanded(child: _buildRadioOption('Present', selectedIndex == 1, () => onFilterChanged(1))),
        SizedBox(width: 5),
        Expanded(child: _buildRadioOption('Late', selectedIndex == 2, () => onFilterChanged(2))),
        SizedBox(width: 5),
        Expanded(child: _buildRadioOption('Absent', selectedIndex == 3, () => onFilterChanged(3))),
      ],
    );
  }

  Widget _buildRadioOption(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        alignment: Alignment.center,
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
}
