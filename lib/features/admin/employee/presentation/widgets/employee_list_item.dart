import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EmployeeListItem extends StatelessWidget {
  final String username;
  final String fullname;
  final String role;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const EmployeeListItem({
    super.key,
    required this.username,
    required this.fullname,
    required this.role,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsGeometry.all(15),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: blackColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildAvatar(context),
          SizedBox(width: 12),
          Expanded(child: _buildEmployeeInfo()),
          SizedBox(width: 8),
          if (onEdit != null) _buildEditButton(),
          if (onEdit != null && onDelete != null) SizedBox(width: 8),
          if (onDelete != null) _buildDeleteButton(),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final isSkeleton = Skeletonizer.maybeOf(context)?.enabled ?? false;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isSkeleton
            ? null
            : LinearGradient(colors: [primaryColor, Color(0xFF799DFF)]),
        color: isSkeleton ? greyColor.withValues(alpha: 0.3) : null,
      ),
      child: Center(
        child: Text(
          fullname.isNotEmpty ? fullname[0].toUpperCase() : 'E',
          style: semiBoldTextStyle.copyWith(fontSize: 20, color: whiteColor),
        ),
      ),
    );
  }

  Widget _buildEmployeeInfo() {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          fullname,
          style: semiBoldTextStyle.copyWith(fontSize: 16, color: blackColor),
        ),
        SizedBox(height: 4),
        Text(
          '@$username',
          style: regularTextStyle.copyWith(fontSize: 13, color: greyColor),
        ),
        SizedBox(height: 4),
        Text(
          role,
          style: mediumTextStyle.copyWith(fontSize: 12, color: greyColor),
        ),
      ],
    );
  }

  Widget _buildEditButton() {
    return GestureDetector(
      onTap: onEdit,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: primaryColor.withValues(alpha: 0.1),
        ),
        child: Icon(Icons.edit_outlined, size: 20, color: primaryColor),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: onDelete,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: redColor.withValues(alpha: 0.1),
        ),
        child: Icon(Icons.delete_outline, size: 20, color: redColor),
      ),
    );
  }
}
