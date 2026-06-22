import 'package:attendance_cnn_app/core/exception/failures.dart';
import 'package:attendance_cnn_app/core/domain/models/users_model.dart';
import 'package:attendance_cnn_app/features/authentication/presentation/providers/auth_notifier.dart';
import 'package:attendance_cnn_app/features/user/profile/presentation/providers/profile_notifier.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:attendance_cnn_app/widget/confirmation_dialog.dart';
import 'package:attendance_cnn_app/widget/loading_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileNotifierProvider);
    final authState = ref.watch(authNotifierProvider);

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
        child: RefreshIndicator(
          backgroundColor: whiteColor,
          color: primaryColor,
          onRefresh: () async {
            await ref.read(profileNotifierProvider.notifier).refetch();
          },
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(25),
                sliver: SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile',
                        style: boldTextStyle.copyWith(fontSize: 18),
                      ),
                      SizedBox(height: 30),
                      _buildProfileContent(profileAsync),
                      SizedBox(height: 30),
                      Text(
                        'General',
                        style: boldTextStyle.copyWith(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      _buildItemProfile(
                        () => context.push('/setting-account'),
                        'assets/ic_profile.png',
                        'Edit Profile',
                      ),

                      Spacer(),

                      GestureDetector(
                        onTap: () => _showLogoutDialog(context),
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).padding.bottom + 10,
                          ),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: redColor.withAlpha(20),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout_rounded,
                                color: redColor,
                                size: 18,
                              ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(AsyncValue<Users?> profileAsync) {
    return profileAsync.when(
      data: (profile) {
        if (profile == null) return _buildLoadingState();

        return Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: primaryColor.withAlpha(25),
                child: Text(
                  _getInitials(profile.name ?? ''),
                  style: boldTextStyle.copyWith(
                    fontSize: 32,
                    color: primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                profile.name ?? 'User',
                style: boldTextStyle.copyWith(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                profile.role?.toUpperCase() ?? 'EMPLOYEE',
                style: regularTextStyle.copyWith(color: greyColor),
              ),
            ],
          ),
        );
      },
      loading: () => _buildLoadingState(),
      error: (error, _) => _buildErrorState(error),
    );
  }

  Widget _buildLoadingState() {
    return Skeletonizer(
      enabled: true,
      child: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: primaryColor.withAlpha(25),
              child: Text('A', style: boldTextStyle.copyWith(fontSize: 20)),
            ),
            SizedBox(height: 20),
            Text('Nama Karyawan', style: boldTextStyle.copyWith(fontSize: 16)),
            SizedBox(height: 5),
            Text(
              'EMPLOYEE',
              style: mediumTextStyle.copyWith(fontSize: 12, color: greyColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: redColor),
            SizedBox(height: 16),
            Text('Failed to load profile', style: semiBoldTextStyle),
            SizedBox(height: 8),
            Text(
              error is Failure ? error.message : error.toString(),
              style: regularTextStyle.copyWith(color: greyColor),
              textAlign: TextAlign.center,
            ),
          ],
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

  String _getInitials(String name) {
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
