import 'package:attendance_cnn_app/core/domain/models/users_model.dart';
import 'package:attendance_cnn_app/features/admin/home/domain/models/dashboard_data.dart';
import 'package:attendance_cnn_app/features/admin/home/presentation/providers/dashboard_notifier.dart';
import 'package:attendance_cnn_app/features/admin/home/presentation/widgets/card_dashboard.dart';
import 'package:attendance_cnn_app/features/admin/profile/presentation/providers/profile_notifier.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeAdminScreen extends ConsumerStatefulWidget {
  const HomeAdminScreen({super.key});

  @override
  ConsumerState<HomeAdminScreen> createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends ConsumerState<HomeAdminScreen> {
  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(dashboardNotifierProvider);
    final profileAsync = ref.watch(profileNotifierProvider);

    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          backgroundColor: whiteColor,
          color: primaryColor,
          onRefresh: () async {
            await ref.read(dashboardNotifierProvider.notifier).refetch();
            await ref.read(profileNotifierProvider.notifier).refetch();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(25),
              child: _buildContent(dashboardAsync, profileAsync),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    AsyncValue<DashboardData> dashboardAsync,
    AsyncValue<Users?> profileAsync,
  ) {
    // Show loading skeleton if either is still loading
    final isLoading = dashboardAsync.isLoading || profileAsync.isLoading;

    if (isLoading) {
      return _buildLoadingState();
    }

    // Check for errors
    if (dashboardAsync.hasError) {
      return _buildErrorState(dashboardAsync.error);
    }

    if (profileAsync.hasError) {
      return _buildErrorState(profileAsync.error);
    }

    // Both loaded successfully
    final profile = profileAsync.value;
    final dashboard = dashboardAsync.value!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (profile != null) _buildHeader(profile) else _buildHeaderSkeleton(),
        SizedBox(height: 35),
        _buildDashboardCards(dashboard),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderSkeleton(),
        SizedBox(height: 35),
        _buildDashboardSkeleton(),
      ],
    );
  }

  Widget _buildHeader(Users profile) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: primaryColor.withAlpha(25),
            child: Text(
              _getInitials(profile.name ?? ''),
              style: boldTextStyle.copyWith(fontSize: 20, color: primaryColor),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name ?? '',
                  style: boldTextStyle.copyWith(fontSize: 16),
                ),
                Text(
                  profile.role?.toUpperCase() ?? '',
                  style: mediumTextStyle.copyWith(
                    fontSize: 12,
                    color: greyColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: primaryColor.withAlpha(25),
              child: Text('A', style: boldTextStyle.copyWith(fontSize: 20)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nama Karyawan Panjang',
                    style: boldTextStyle.copyWith(fontSize: 16),
                  ),
                  Text(
                    'ADMIN',
                    style: mediumTextStyle.copyWith(
                      fontSize: 12,
                      color: greyColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCards(DashboardData dashboard) {
    return CardDashboard(data: dashboard);
  }

  Widget _buildDashboardSkeleton() {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        highlightColor: greyColor.withAlpha(50),
        baseColor: greyColor.withAlpha(25),
      ),
      child: CardDashboard(data: null),
    );
  }

  Widget _buildErrorState(Object? error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: redColor),
            SizedBox(height: 16),
            Text('Failed to load dashboard', style: semiBoldTextStyle),
            SizedBox(height: 8),
            Text(
              error?.toString() ?? 'Unknown error',
              style: regularTextStyle.copyWith(color: greyColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
