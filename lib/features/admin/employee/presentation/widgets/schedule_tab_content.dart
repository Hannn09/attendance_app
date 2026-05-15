import 'package:attendance_cnn_app/features/admin/employee/domain/models/schedule_list.dart';
import 'package:attendance_cnn_app/features/admin/employee/domain/models/schedule_request.dart';
import 'package:attendance_cnn_app/features/admin/employee/presentation/providers/schedule_list_notifier.dart';
import 'package:attendance_cnn_app/features/admin/employee/presentation/providers/schedule_action_notiifier.dart';
import 'package:attendance_cnn_app/features/admin/employee/presentation/widgets/schedule_date_selector.dart';
import 'package:attendance_cnn_app/features/admin/employee/presentation/widgets/schedule_list_item.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ScheduleTabContent extends ConsumerStatefulWidget {
  const ScheduleTabContent({super.key});

  @override
  ConsumerState<ScheduleTabContent> createState() => _ScheduleTabContentState();
}

class _ScheduleTabContentState extends ConsumerState<ScheduleTabContent> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Load schedules for current date on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(scheduleListNotifierProvider.notifier)
          .refetchWithDate(_selectedDate);
    });
  }

  void _onDateChanged(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    ref.read(scheduleListNotifierProvider.notifier).refetchWithDate(date);
  }

  void _onShiftTap(
    BuildContext context,
    ScheduleList schedule,
    AsyncValue<void> updateAsync,
  ) {
    if (updateAsync.isLoading) return;

    final currentShift = _capitalizeShiftName(schedule.shiftName);
    final userId = schedule.userId;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User ID not found'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _showShiftSelectionMenu(context, userId, currentShift);
  }

  void _showShiftSelectionMenu(
    BuildContext context,
    int userId,
    String currentShift,
  ) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset offset = button.localToGlobal(Offset.zero);
    final Size size = button.size;

    final shiftTypes = ['Pagi', 'Siang', 'Malam', 'Libur'];

    showMenu<String>(
      context: context,
      color: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: borderColor),
      ),
      position: RelativeRect.fromLTRB(
        offset.dx + size.width - 100,
        offset.dy + (size.height / 1.5),
        offset.dx + size.width,
        0,
      ),
      items: shiftTypes.map((shift) {
        return PopupMenuItem<String>(
          value: shift,
          child: Row(
            children: [
              Icon(
                _getShiftIcon(shift),
                color: _getShiftColor(shift),
                size: 20,
              ),
              SizedBox(width: 12),
              Text(
                shift,
                style: mediumTextStyle.copyWith(
                  fontSize: 14,
                  color: blackColor,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ).then((value) async {
      if (value != null && value != currentShift) {
        final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
        final shiftValue = value.toLowerCase();

        if (!mounted) return;

        final request = ScheduleRequest(
          date: formattedDate,
          shiftName: shiftValue,
        );

        await ref
            .read(scheduleActionNotifierProvider.notifier)
            .upsertSchedule(request, userId);

        if (!mounted) return;
        final actionState = ref.read(scheduleActionNotifierProvider);
        actionState.when(
          data: (_) {
            ref
                .read(scheduleListNotifierProvider.notifier)
                .refetchWithDate(_selectedDate);

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Schedule updated successfully'),
                  backgroundColor: greenColor,
                ),
              );
            }
          },
          error: (error, _) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to update schedule: $error'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          loading: () {},
        );
      }
    });
  }

  String _capitalizeShiftName(String? shiftName) {
    if (shiftName == null || shiftName.isEmpty) {
      return 'Belum diatur';
    }
    return shiftName[0].toUpperCase() + shiftName.substring(1).toLowerCase();
  }

  IconData _getShiftIcon(String shift) {
    switch (shift.toLowerCase()) {
      case 'pagi':
        return Icons.wb_sunny;
      case 'siang':
        return Icons.wb_twilight;
      case 'malam':
        return Icons.bedtime;
      case 'libur':
        return Icons.free_breakfast;
      default:
        return Icons.schedule;
    }
  }

  Color _getShiftColor(String shift) {
    switch (shift.toLowerCase()) {
      case 'pagi':
        return greenColor;
      case 'siang':
        return orangeColor;
      case 'malam':
        return primaryColor;
      case 'libur':
        return greyColor;
      default:
        return greyColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheduleListAsync = ref.watch(scheduleListNotifierProvider);
    final scheduleActionState = ref.watch(scheduleActionNotifierProvider);

    return Column(
      children: [
        ScheduleDateSelector(
          selectedDate: _selectedDate,
          onDateChanged: _onDateChanged,
        ),
        SizedBox(height: 15),
        scheduleListAsync.when(
          data: (schedules) {
            if (schedules.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      size: 64,
                      color: greyColor.withAlpha(50),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No schedules found',
                      style: mediumTextStyle.copyWith(
                        fontSize: 16,
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: schedules.length,
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                // Gunakan kombinasi userId dan index sebagai key yang unik
                final uniqueKey =
                    '${schedule.userId}_${schedule.scheduleId}_$index';
                return Builder(
                  builder: (itemContext) {
                    return ScheduleListItem(
                      key: ValueKey(uniqueKey),
                      employeeName: schedule.name ?? 'Unknown',
                      shiftType: _capitalizeShiftName(schedule.shiftName),
                      onShiftTap: () => _onShiftTap(
                        itemContext,
                        schedule,
                        scheduleActionState,
                      ),
                    );
                  },
                );
              },
            );
          },
          loading: () => _buildSkeletonLoader(),
          error: (error, stack) => Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.withAlpha(50),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Failed to load schedules',
                    style: semiBoldTextStyle.copyWith(
                      fontSize: 16,
                      color: blackColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: regularTextStyle.copyWith(
                      fontSize: 14,
                      color: greyColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(scheduleListNotifierProvider.notifier)
                          .refetchWithDate(_selectedDate);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: whiteColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Try Again',
                      style: semiBoldTextStyle.copyWith(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonLoader() {
    return Skeletonizer(
      enabled: true,
      enableSwitchAnimation: true,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          return ScheduleListItem(
            employeeName: 'Employee Name',
            shiftType: 'Shift Type',
          );
        },
      ),
    );
  }
}
