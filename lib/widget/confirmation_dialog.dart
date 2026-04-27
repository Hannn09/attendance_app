import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

enum IconType { svg, png }

class ConfirmationDialog extends StatelessWidget {
  final String? iconPath;
  final IconType iconType;
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final VoidCallback? onConfirm;

  const ConfirmationDialog({
    super.key,
    this.iconPath,
    this.iconType = IconType.svg,
    required this.title,
    required this.message,
    this.cancelText = 'Cancel',
    this.confirmText = 'Confirm',
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconPath != null)
            iconType == IconType.png
                ? Image.asset(iconPath!, width: 48, height: 48)
                : SvgPicture.asset(iconPath!),
          if (iconPath != null) SizedBox(height: 15),
          Text(
            title,
            style: boldTextStyle.copyWith(color: blackColor, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Text(
        textAlign: TextAlign.center,
        message,
        style: regularTextStyle.copyWith(color: blackColor),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  shadowColor: Colors.transparent,
                  overlayColor: Colors.transparent,
                ),
                onPressed: () => context.pop(),
                child: Text(
                  cancelText,
                  style: boldTextStyle.copyWith(color: primaryColor),
                ),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: ElevatedButton(
                style: primaryButtonStyle,
                onPressed: () {
                  context.pop();
                  onConfirm?.call();
                },
                child: Text(
                  confirmText,
                  style: boldTextStyle.copyWith(color: whiteColor),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
