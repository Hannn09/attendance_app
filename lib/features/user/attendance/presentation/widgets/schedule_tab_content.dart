import 'package:attendance_cnn_app/features/admin/employee/domain/models/schedule_list.dart';
import 'package:attendance_cnn_app/features/admin/employee/presentation/providers/schedule_list_notifier.dart';
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

  String _capitalizeShiftName(String? shiftName) {
    if (shiftName == null || shiftName.isEmpty) {
      return 'Belum diatur';
    }
    return shiftName[0].toUpperCase() + shiftName.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final scheduleListAsync = ref.watch(scheduleListNotifierProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDateHeader(),
        SizedBox(height: 15),
        _buildScheduleList(scheduleListAsync),
      ],
    );
  }

  Widget _buildDateHeader() {
    final formattedDate = DateFormat('MMMM yyyy').format(_selectedDate);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(formattedDate, style: boldTextStyle.copyWith(fontSize: 18)),
            ],
          ),
        ),
        SizedBox(height: 12),
        _buildDateSelector(),
      ],
    );
  }

  Widget _buildDateSelector() {
    final dates = List.generate(
      7,
      (index) => DateTime.now().add(Duration(days: index)),
    );

    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: dates.length,
        itemExtent: 55,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _isSameDay(date, _selectedDate);

          return GestureDetector(
            onTap: () => _onDateChanged(date),
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
      margin: EdgeInsets.only(right: 8),
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
                  color: primaryColor.withOpacity(0.3),
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

  Widget _buildScheduleList(AsyncValue<List<ScheduleList>> scheduleListAsync) {
    return scheduleListAsync.when(
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
                  'No schedules for this day',
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
            return _buildScheduleCard(schedule);
          },
        );
      },
      loading: () => _buildLoadingState(),
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
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
    );
  }

  Widget _buildLoadingState() {
    final skeletonSchedules = List.generate(
      7,
      (index) => ScheduleList(name: 'Employee Name', shiftName: 'Pagi'),
    );

    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        highlightColor: greyColor.withAlpha(50),
        baseColor: greyColor.withAlpha(25),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: skeletonSchedules.length,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final schedule = skeletonSchedules[index];
          return _buildScheduleCard(schedule);
        },
      ),
    );
  }

  Widget _buildScheduleCard(ScheduleList schedule) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.10),
            offset: Offset(0, 4),
            blurRadius: 15,
          ),
        ],
      ),
      child: Row(
        children: [
          _buildAvatar(schedule),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule.name ?? 'Unknown',
                  style: boldTextStyle.copyWith(fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  'Employee',
                  style: regularTextStyle.copyWith(
                    fontSize: 12,
                    color: greyColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          _buildShiftBadge(_capitalizeShiftName(schedule.shiftName)),
        ],
      ),
    );
  }

  Widget _buildAvatar(ScheduleList schedule) {
    final initial = (schedule.name?.isNotEmpty ?? false)
        ? schedule.name![0].toUpperCase()
        : '?';

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: boldTextStyle.copyWith(fontSize: 18, color: primaryColor),
        ),
      ),
    );
  }

  Widget _buildShiftBadge(String shiftType) {
    Color backgroundColor;
    Color textColor;

    switch (shiftType.toLowerCase()) {
      case 'pagi':
        backgroundColor = greenColor.withOpacity(0.1);
        textColor = greenColor;
        break;
      case 'siang':
        backgroundColor = orangeColor.withOpacity(0.1);
        textColor = orangeColor;
        break;
      case 'malam':
        backgroundColor = primaryColor.withOpacity(0.1);
        textColor = primaryColor;
        break;
      case 'libur':
        backgroundColor = lightGreyColor.withOpacity(0.3);
        textColor = greyColor;
        break;
      case 'belum diatur':
        backgroundColor = lightGreyColor.withOpacity(0.3);
        textColor = greyColor;
        break;
      default:
        backgroundColor = greyColor.withOpacity(0.1);
        textColor = greyColor;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        shiftType,
        style: mediumTextStyle.copyWith(fontSize: 11, color: textColor),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
