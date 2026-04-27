import 'package:attendance_cnn_app/features/authentication/presentation/providers/auth_notifier.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:attendance_cnn_app/widget/confirmation_dialog.dart';
import 'package:attendance_cnn_app/widget/loading_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // auth state listener
    ref.listen(authNotifierProvider, (previous, next) {
      if (next.isLoading) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => LoadingStateWidget(),
        );
      } else if (previous?.isLoading == true && !next.isLoading) {
        if (mounted && Navigator.canPop(context)) {
          context.pop();
        }
      }

      next.whenOrNull(
        data: (user) {
          if (user == null) {
            context.go('/login');
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                error.toString(),
                style: regularTextStyle.copyWith(color: whiteColor),
              ),
              backgroundColor: redColor,
            ),
          );
        },
      );
    });
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsetsGeometry.all(25),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text('Profile', style: boldTextStyle.copyWith(fontSize: 18)),
              SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/dummy_profile.png', width: 85),
                    SizedBox(height: 20),
                    Text(
                      'Muhammad Sumbul',
                      style: boldTextStyle.copyWith(fontSize: 18),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'muhammadsumbul99@gmail.com',
                      style: regularTextStyle.copyWith(color: greyColor),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Text('General', style: boldTextStyle.copyWith(fontSize: 16)),
              SizedBox(height: 20),
              _buildItemProfile(() {}, 'assets/ic_profile.png', 'Edit Profile'),
              Spacer(),
              GestureDetector(
                onTap: () => _showLogoutDialog(context),
                child: Container(
                  margin: EdgeInsets.only(bottom: 80),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: redColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .center,
                    children: [
                      Icon(Icons.logout_rounded, color: redColor, size: 18),
                      SizedBox(width: 5),
                      Text(
                        'Logout',
                        style: boldTextStyle.copyWith(color: redColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemProfile(VoidCallback onTap, String iconPath, String title) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 15),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.2),
              ),
              child: Image.asset(iconPath, width: 24, color: primaryColor),
            ),
            Expanded(child: Text(title, style: mediumTextStyle)),

            Icon(Icons.arrow_forward_ios_rounded, size: 18, color: greyColor),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => ConfirmationDialog(
        iconPath: 'assets/ic_warning.svg',
        title: 'Logout from App?',
        message: 'You will be log out from app. See you soon!',
        cancelText: 'Cancel',
        confirmText: 'Logout',
        onConfirm: () {
          ref.read(authNotifierProvider.notifier).logout();
        },
      ),
    );
  }
}
