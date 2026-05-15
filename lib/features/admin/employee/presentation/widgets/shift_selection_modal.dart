import 'package:attendance_cnn_app/features/admin/employee/domain/models/shift_type.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';

class ShiftSelectionModal extends StatelessWidget {
  final String employeeName;
  final ShiftType currentShift;
  final ValueChanged<ShiftType> onShiftSelected;

  const ShiftSelectionModal({
    super.key,
    required this.employeeName,
    required this.currentShift,
    required this.onShiftSelected,
  });

  static void show(
    BuildContext context, {
    required String employeeName,
    required ShiftType currentShift,
    required ValueChanged<ShiftType> onShiftSelected,
  }) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ShiftSelectionModal(
        employeeName: employeeName,
        currentShift: currentShift,
        onShiftSelected: onShiftSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            SizedBox(height: 20),
            _buildShiftOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Shift', style: boldTextStyle.copyWith(fontSize: 18)),
            SizedBox(height: 2),
            Text(
              employeeName,
              style: mediumTextStyle.copyWith(fontSize: 13, color: greyColor),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: greyColor.withValues(alpha: 0.1),
            ),
            child: Icon(Icons.close, size: 18, color: greyColor),
          ),
        ),
      ],
    );
  }

  Widget _buildShiftOptions(BuildContext context) {
    return Column(
      children: ShiftType.values.map((shift) {
        final isSelected = shift == currentShift;
        return Padding(
          padding: EdgeInsetsGeometry.only(bottom: 10),
          child: _buildShiftOption(context, shift, isSelected),
        );
      }).toList(),
    );
  }

  Widget _buildShiftOption(
    BuildContext context,
    ShiftType shift,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        onShiftSelected(shift);
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withValues(alpha: 0.08) : whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : borderColor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(shift.emoji, style: TextStyle(fontSize: 24)),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shift.displayName.toUpperCase(),
                    style: semiBoldTextStyle.copyWith(
                      fontSize: 14,
                      color: isSelected ? primaryColor : blackColor,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    shift.timeRange,
                    style: mediumTextStyle.copyWith(
                      fontSize: 12,
                      color: greyColor,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: primaryColor, size: 20),
          ],
        ),
      ),
    );
  }
}
