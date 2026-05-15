import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';

class ReportSearchBar extends StatelessWidget {
  final VoidCallback onFilterTap;
  final ValueChanged<String>? onSearchChanged;

  const ReportSearchBar({
    super.key,
    required this.onFilterTap,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Padding(padding: EdgeInsets.only(left: 16)),
          Icon(Icons.search, color: greyColor, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search employees...',
                hintStyle: hintTextStyle,
              ),
            ),
          ),
          GestureDetector(
            onTap: onFilterTap,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.filter_list, color: primaryColor, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
