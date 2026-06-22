import 'dart:async';
import 'dart:io';

import 'package:attendance_cnn_app/features/user/attendance/domain/providers/attendance_state_provider.dart';
import 'package:attendance_cnn_app/features/user/attendance/presentation/providers/attendance_data_notifier.dart';
import 'package:attendance_cnn_app/features/user/attendance/presentation/widgets/attendance_tab_bar.dart';
import 'package:attendance_cnn_app/features/user/attendance/presentation/widgets/camera_capture_screen.dart';
import 'package:attendance_cnn_app/features/user/attendance/presentation/widgets/schedule_tab_content.dart';
import 'package:attendance_cnn_app/features/user/attendance/presentation/widgets/today_tab_content.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:attendance_cnn_app/widget/confirmation_dialog.dart';
import 'package:attendance_cnn_app/widget/loading_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  final int userId;
  final List<double> faceEmbedding;

  const AttendanceScreen({
    super.key,
    required this.userId,
    required this.faceEmbedding,
  });

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  int _selectedTabIndex = 0;
  Timer? _timeTimer;
  String _currentTime = '';
  String _currentDate = '';

  late final AttendanceNotifier _attendanceNotifier;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timeTimer = Timer.periodic(Duration(seconds: 1), (_) => _updateTime());

    _attendanceNotifier = ref.read(
      createAttendanceNotifierProvider(
        AttendanceUserParams(
          userId: widget.userId,
          faceEmbedding: widget.faceEmbedding,
        ),
      ).notifier,
    );
  }

  Future<void> _refreshTodayAttendance() async {
    // Refresh the provider to force refetch
    ref.refresh(attendanceDataNotifierProvider(widget.userId));

    // Wait a bit for the refresh to complete
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _timeTimer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(now);
      _currentDate = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(now);
    });
  }

  Future<void> _handleCheckIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationDialog(
        iconPath: 'assets/ic_warning.svg',
        title: 'Check In',
        message:
            'Apakah Anda yakin ingin check-in sekarang? Pastikan wajah Anda terlihat jelas.',
        cancelText: 'Batal',
        confirmText: 'Ya, Check In',
        onConfirm: () => _requestCameraPermissionAndProceed(true),
      ),
    );
  }

  Future<void> _handleCheckOut() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationDialog(
        iconPath: 'assets/ic_warning.svg',
        title: 'Check Out',
        message:
            'Apakah Anda yakin ingin check-out sekarang? Pastikan wajah Anda terlihat jelas.',
        cancelText: 'Batal',
        confirmText: 'Ya, Check Out',
        onConfirm: () => _requestCameraPermissionAndProceed(false),
      ),
    );
  }

  Future<void> _requestCameraPermissionAndProceed(bool isCheckIn) async {
    final cameraStatus = await Permission.camera.request();
    final locationStatus = await Permission.location.request();

    if (!cameraStatus.isGranted || !locationStatus.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Camera dan lokasi diperlukan untuk absensi'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (mounted) {
      final result = await Navigator.push<File>(
        context,
        MaterialPageRoute(
          builder: (context) => CameraCaptureScreen(
            title: isCheckIn ? 'Check In' : 'Check Out',
            instruction: 'Pastikan wajah Anda berada di dalam area lingkaran',
          ),
        ),
      );

      // Process check-in/check-out after receiving image file
      if (result != null) {
        if (isCheckIn) {
          await _attendanceNotifier.processCheckIn(result);
        } else {
          await _attendanceNotifier.processCheckOut(result);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final attendanceActionState = ref.watch(attendanceNotifierProvider);
    final attendanceState = ref.watch(
      createAttendanceNotifierProvider(
        AttendanceUserParams(
          userId: widget.userId,
          faceEmbedding: widget.faceEmbedding,
        ),
      ),
    );

    // Listen to state changes
    ref.listen<AttendanceState>(
      createAttendanceNotifierProvider(
        AttendanceUserParams(
          userId: widget.userId,
          faceEmbedding: widget.faceEmbedding,
        ),
      ),
      (previous, next) {
        if (!mounted) return;

        // Show snackbar on success (only when status changes TO success)
        if (next.status == AttendanceStatus.success &&
            previous?.status != AttendanceStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.message ?? 'Berhasil'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          // Refresh attendance data after successful check-in/out
          _refreshTodayAttendance();
          // Reset state after showing snackbar
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              _attendanceNotifier.resetState();
            }
          });
        }

        // Show snackbar on error (only when status changes TO error)
        if (next.status == AttendanceStatus.error &&
            previous?.status != AttendanceStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.message ?? 'Terjadi kesalahan'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
          // Reset state after showing snackbar
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              _attendanceNotifier.resetState();
            }
          });
        }
      },
    );

    final isLoading = attendanceState.status == AttendanceStatus.loading;

    return Scaffold(
      backgroundColor: whiteColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsGeometry.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            size: 24,
                            color: blackColor,
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          'Attendance Screen',
                          style: boldTextStyle.copyWith(color: blackColor),
                        ),
                      ],
                    ),

                    SizedBox(height: 55),
                    Text(
                      _currentDate,
                      style: mediumTextStyle.copyWith(
                        fontSize: 16,
                        color: blackColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      _currentTime,
                      style: boldTextStyle.copyWith(
                        fontSize: 28,
                        color: blackColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildCheckInCard(attendanceState),
                        _buildButtonAttendance(attendanceState),
                        _buildCheckOutCard(attendanceState),
                      ],
                    ),
                    SizedBox(height: 35),
                    AttendanceTabBar(
                      selectedIndex: _selectedTabIndex,
                      onTabChanged: (index) {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                    ),
                    SizedBox(height: 35),
                    _buildTabContent(),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading) const Positioned.fill(child: LoadingStateWidget()),
        ],
      ),
    );
  }

  Widget _buildCheckInCard(AttendanceState state) {
    final attendanceAsync = ref.watch(
      attendanceDataNotifierProvider(widget.userId),
    );

    return attendanceAsync.when(
      data: (attendance) {
        final checkInTime =
            _formatTime(attendance?.checkInTime) ?? state.checkInTime;
        return _buildCheckInCardContent(checkInTime ?? '--:--');
      },
      loading: () => _buildCheckInCardContent('--:--'),
      error: (_, _) => _buildCheckInCardContent(state.checkInTime ?? '--:--'),
    );
  }

  Widget _buildCheckInCardContent(String? time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Check In', style: mediumTextStyle.copyWith(color: greyColor)),
        Container(
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: primaryColor.withAlpha(20),
            borderRadius: BorderRadius.circular(7),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            time ?? '--:--',
            style: boldTextStyle.copyWith(
              color: primaryColor,
              fontSize: 18,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckOutCard(AttendanceState state) {
    final attendanceAsync = ref.watch(
      attendanceDataNotifierProvider(widget.userId),
    );

    return attendanceAsync.when(
      data: (attendance) {
        final checkOutTime =
            _formatTime(attendance?.checkOutTime) ?? state.checkOutTime;
        return _buildCheckOutCardContent(checkOutTime ?? '--:--');
      },
      loading: () => _buildCheckOutCardContent('--:--'),
      error: (_, _) => _buildCheckOutCardContent(state.checkOutTime ?? '--:--'),
    );
  }

  Widget _buildCheckOutCardContent(String? time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Check Out', style: mediumTextStyle.copyWith(color: greyColor)),
        Container(
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: primaryColor.withAlpha(20),
            borderRadius: BorderRadius.circular(7),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            time ?? '--:--',
            style: boldTextStyle.copyWith(
              color: primaryColor,
              fontSize: 18,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ],
    );
  }

  String? _formatTime(String? time) {
    if (time == null) return null;
    final parts = time.split(':');
    if (parts.length >= 2) {
      try {
        int hour = int.parse(parts[0]);
        final minute = parts[1];

        // Add 7 hours for UTC conversion (WIB = UTC+7)
        hour = (hour + 7) % 24;

        return '${hour.toString().padLeft(2, '0')}:$minute';
      } catch (e) {
        return time;
      }
    }
    return time;
  }

  Widget _buildTabContent() {
    final attendanceAsync = ref.watch(
      attendanceDataNotifierProvider(widget.userId),
    );

    return attendanceAsync.when(
      data: (attendance) {
        switch (_selectedTabIndex) {
          case 0:
            return TodayTabContent(attendance: attendance);
          case 1:
            return ScheduleTabContent();
          default:
            return SizedBox.shrink();
        }
      },
      loading: () {
        switch (_selectedTabIndex) {
          case 0:
            return TodayTabContent(attendance: null);
          case 1:
            return ScheduleTabContent();
          default:
            return SizedBox.shrink();
        }
      },
      error: (_, __) {
        switch (_selectedTabIndex) {
          case 0:
            return TodayTabContent(attendance: null);
          case 1:
            return ScheduleTabContent();
          default:
            return SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildButtonAttendance(AttendanceState state) {
    final attendanceAsync = ref.watch(
      attendanceDataNotifierProvider(widget.userId),
    );

    return attendanceAsync.when(
      data: (attendance) {
        final hasCheckIn =
            attendance?.checkInTime != null &&
            attendance!.checkInTime!.isNotEmpty;
        final hasCheckOut =
            attendance?.checkOutTime != null &&
            attendance!.checkOutTime!.isNotEmpty;
        final isCompleted = hasCheckIn && hasCheckOut;
        final isLoading = state.status == AttendanceStatus.loading;

        return GestureDetector(
          onTap: isLoading || isCompleted
              ? null
              : (hasCheckIn ? _handleCheckOut : _handleCheckIn),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: isLoading || isCompleted
                    ? [greyColor, greyColor]
                    : [primaryColor, Color(0xFF799DFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1.0],
              ),
            ),
            child: isLoading
                ? SizedBox(
                    width: 35,
                    height: 35,
                    child: CircularProgressIndicator(
                      color: whiteColor,
                      strokeWidth: 3,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        isCompleted
                            ? Icons.check_circle
                            : hasCheckIn
                            ? Icons.logout
                            : Icons.login,
                        size: 35,
                        color: whiteColor,
                      ),
                      SizedBox(height: 5),
                      Text(
                        isCompleted
                            ? 'Selesai'
                            : hasCheckIn
                            ? 'Check Out'
                            : 'Check In',
                        style: boldTextStyle.copyWith(
                          fontSize: 16,
                          color: whiteColor,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
      loading: () => _buildButtonLoading(),
      error: (_, __) => _buildButtonLoading(),
    );
  }

  Widget _buildButtonLoading() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [greyColor, greyColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 1.0],
        ),
      ),
      child: SizedBox(
        width: 35,
        height: 35,
        child: CircularProgressIndicator(color: whiteColor, strokeWidth: 3),
      ),
    );
  }
}
