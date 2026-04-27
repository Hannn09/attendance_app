import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleDateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const ScheduleDateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Generate dates for the next 14 days starting from today
    final dates = List.generate(
      14,
      (index) => DateTime.now().add(Duration(days: index)),
    );

    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
        itemCount: dates.length,
        itemExtent: 55,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _isSameDay(date, selectedDate);

          return GestureDetector(
            onTap: () => onDateChanged(date),
            child: _buildDateChip(date, isSelected),
          );
        },
      ),
    );
  }

  Widget _buildDateChip(DateTime date, bool isSelected) {
    final dayName = DateFormat.E().format(date).substring(0, 3);
    final dayNumber = DateFormat.d().format(date);

    return Container(
      margin: EdgeInsetsGeometry.only(right: 8),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor : whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? primaryColor : borderColor,
          width: 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dayName,
            style: mediumTextStyle.copyWith(
              fontSize: 11,
              color: isSelected ? whiteColor : greyColor,
            ),
          ),
          SizedBox(height: 4),
          Text(
            dayNumber,
            style: boldTextStyle.copyWith(
              fontSize: 16,
              color: isSelected ? whiteColor : blackColor,
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
