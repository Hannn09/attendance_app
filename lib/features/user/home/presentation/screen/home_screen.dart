import 'package:attendance_cnn_app/core/domain/models/users_model.dart';
import 'package:attendance_cnn_app/features/authentication/presentation/providers/auth_notifier.dart';
import 'package:attendance_cnn_app/features/user/attendance/presentation/providers/attendance_data_notifier.dart';
import 'package:attendance_cnn_app/features/user/home/domain/models/dashboard_users_data.dart';
import 'package:attendance_cnn_app/features/user/home/presentation/provider/dashboard_user_notifier.dart';
import 'package:attendance_cnn_app/features/user/home/presentation/widgets/card_information_checkin.dart';
import 'package:attendance_cnn_app/features/user/profile/presentation/providers/profile_notifier.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Attendance data will be fetched automatically when the provider is watched
  }

  Future<void> _refreshAttendanceData() async {
    final profile = await ref.read(profileNotifierProvider.future);
    if (profile != null) {
      ref.invalidate(attendanceDataNotifierProvider(profile.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileNotifierProvider);
    final dashboardAsync = ref.watch(dashboardUserNotifierProvider);

    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          backgroundColor: whiteColor,
          color: primaryColor,
          onRefresh: () async {
            await ref.read(profileNotifierProvider.notifier).refetch();
            await ref.read(dashboardUserNotifierProvider.notifier).refetch();
            await _refreshAttendanceData();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsetsGeometry.all(25),
              child: _buildContent(profileAsync, dashboardAsync),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    AsyncValue<Users?> profileAsync,
    AsyncValue<DashboardUsersData> dashboardAsync,
  ) {
    // Show loading skeleton if either is still loading
    final isLoading = profileAsync.isLoading || dashboardAsync.isLoading;

    if (isLoading) {
      return _buildLoadingState();
    }

    // Check for errors
    if (profileAsync.hasError) {
      return _buildErrorState(profileAsync.error);
    }

    if (dashboardAsync.hasError) {
      return _buildErrorState(dashboardAsync.error);
    }

    // Both loaded successfully
    final profile = profileAsync.value;
    final dashboard = dashboardAsync.value!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (profile != null) _buildHeader(profile) else _buildHeaderSkeleton(),
        SizedBox(height: 35),
        CardInformationCheckin(),
        SizedBox(height: 25),
        Text('Summary This Month', style: boldTextStyle.copyWith(fontSize: 16)),
        SizedBox(height: 15),
        _buildSummaryCards(dashboard),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderSkeleton(),
        SizedBox(height: 35),
        Skeletonizer(
          enabled: true,
          effect: ShimmerEffect(
            highlightColor: greyColor.withAlpha(50),
            baseColor: greyColor.withAlpha(25),
          ),
          child: CardInformationCheckin(),
        ),
        SizedBox(height: 25),
        Text('Summary This Month', style: boldTextStyle.copyWith(fontSize: 16)),
        SizedBox(height: 15),
        _buildSummaryCards(null),
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
                  profile.name ?? 'User',
                  style: boldTextStyle.copyWith(fontSize: 16),
                ),
                Text(
                  profile.role?.toUpperCase() ?? 'EMPLOYEE',
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
        margin: EdgeInsets.only(top: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: primaryColor.withAlpha(25),
              child: Text('A', style: boldTextStyle.copyWith(fontSize: 20)),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nama Karyawan',
                    style: boldTextStyle.copyWith(fontSize: 16),
                  ),
                  Text(
                    'EMPLOYEE',
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

  Widget _buildSummaryCards(DashboardUsersData? dashboard) {
    final isLoading = dashboard == null;

    return Skeletonizer(
      enabled: isLoading,
      effect: ShimmerEffect(
        highlightColor: greyColor.withAlpha(50),
        baseColor: greyColor.withAlpha(25),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildCardSummary(
                  'Present',
                  '${dashboard?.presentCount ?? 20} Days',
                  Icons.calendar_today_outlined,
                  greenColor,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _buildCardSummary(
                  'Absent',
                  '${dashboard?.absentCount ?? 5} Days',
                  Icons.access_time,
                  redColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildCardSummary(
                  'Overtime',
                  '${dashboard?.overtimeCount ?? 3} Hours',
                  Icons.more_time_sharp,
                  primaryColor,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _buildCardSummary(
                  'Late',
                  '${dashboard?.lateCount ?? 3} Hours',
                  Icons.warning_amber_rounded,
                  orangeColor,
                ),
              ),
            ],
          ),
        ],
      ),
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
            Text('Failed to load data', style: semiBoldTextStyle),
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

  Widget _buildCardSummary(
    String title,
    String content,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 8),
            blurRadius: 15,
            color: blackColor.withValues(alpha: 0.10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: iconColor.withAlpha(50),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: mediumTextStyle.copyWith(color: greyColor)),
              Text(
                content,
                style: boldTextStyle.copyWith(color: blackColor, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
