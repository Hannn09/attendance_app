import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';

enum ScheduleStatus { onSchedule, late, absent, off }

class EmployeeSchedule {
  final String name;
  final String department;
  final String shiftStart;
  final String shiftEnd;
  final ScheduleStatus status;
  final String? avatarPath;

  EmployeeSchedule({
    required this.name,
    required this.department,
    required this.shiftStart,
    required this.shiftEnd,
    required this.status,
    this.avatarPath,
  });
}

class ScheduleTabContent extends StatefulWidget {
  const ScheduleTabContent({super.key});

  @override
  State<ScheduleTabContent> createState() => _ScheduleTabContentState();
}

class _ScheduleTabContentState extends State<ScheduleTabContent> {
  int _selectedFilter = 0;

  final List<EmployeeSchedule> mockSchedules = [
    EmployeeSchedule(
      name: 'Muhammad Sumbul',
      department: 'Engineering',
      shiftStart: '08:00',
      shiftEnd: '17:00',
      status: ScheduleStatus.onSchedule,
    ),
    EmployeeSchedule(
      name: 'Sarah Wijaya',
      department: 'Design',
      shiftStart: '09:00',
      shiftEnd: '18:00',
      status: ScheduleStatus.late,
    ),
    EmployeeSchedule(
      name: 'Budi Santoso',
      department: 'Marketing',
      shiftStart: '08:00',
      shiftEnd: '17:00',
      status: ScheduleStatus.onSchedule,
    ),
    EmployeeSchedule(
      name: 'Dewi Lestari',
      department: 'HR',
      shiftStart: '14:00',
      shiftEnd: '22:00',
      status: ScheduleStatus.off,
    ),
    EmployeeSchedule(
      name: 'Ahmad Rahman',
      department: 'Engineering',
      shiftStart: '22:00',
      shiftEnd: '06:00',
      status: ScheduleStatus.absent,
    ),
    EmployeeSchedule(
      name: 'Rina Kusuma',
      department: 'Finance',
      shiftStart: '08:00',
      shiftEnd: '17:00',
      status: ScheduleStatus.onSchedule,
    ),
    EmployeeSchedule(
      name: 'Doni Pratama',
      department: 'Operations',
      shiftStart: '14:00',
      shiftEnd: '22:00',
      status: ScheduleStatus.late,
    ),
    EmployeeSchedule(
      name: 'Fitri Handayani',
      department: 'Design',
      shiftStart: '08:00',
      shiftEnd: '17:00',
      status: ScheduleStatus.onSchedule,
    ),
  ];

  List<EmployeeSchedule> get _filteredSchedules {
    if (_selectedFilter == 0) return mockSchedules;

    return mockSchedules.where((schedule) {
      final startHour = int.tryParse(schedule.shiftStart.split(':')[0]) ?? 0;

      switch (_selectedFilter) {
        case 1: // Morning Shift: 06:00 - 14:00
          return startHour >= 6 && startHour < 14;
        case 2: // Afternoon Shift: 14:00 - 22:00
          return startHour >= 14 && startHour < 22;
        case 3: // Night Shift: 22:00 - 06:00
          return startHour >= 22 || startHour < 6;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildFilterTabs(),
        SizedBox(height: 15),
        _buildScheduleList(),
      ],
    );
  }

  Widget _buildFilterTabs() {
    final filters = ['All', 'Morning', 'Afternoon', 'Night'];

    return Row(
        children: List.generate(filters.length, (index) {
          final isSelected = _selectedFilter == index;
          return Padding(
            padding: EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = index;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : whiteColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? primaryColor : borderColor,
                  ),
                ),
                child: Text(
                  filters[index],
                  style: mediumTextStyle.copyWith(
                    fontSize: 12,
                    color: isSelected ? whiteColor : blackColor,
                  ),
                ),
              ),
            ),
          );
        }),
    );
  }

  Widget _buildScheduleList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _filteredSchedules.length,
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildScheduleCard(_filteredSchedules[index]);
      },
    );
  }

  Widget _buildScheduleCard(EmployeeSchedule schedule) {
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
                  schedule.name,
                  style: boldTextStyle.copyWith(fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  schedule.department,
                  style: regularTextStyle.copyWith(
                    fontSize: 12,
                    color: greyColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '${schedule.shiftStart} - ${schedule.shiftEnd}',
                  style: mediumTextStyle.copyWith(
                    fontSize: 12,
                    color: blackColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          _buildStatusBadge(schedule.status),
        ],
      ),
    );
  }

  Widget _buildAvatar(EmployeeSchedule schedule) {
    final initial = schedule.name.isNotEmpty
        ? schedule.name[0].toUpperCase()
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

  Widget _buildStatusBadge(ScheduleStatus status) {
    String label;
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case ScheduleStatus.onSchedule:
        label = 'On Schedule';
        backgroundColor = greenColor.withOpacity(0.1);
        textColor = greenColor;
        break;
      case ScheduleStatus.late:
        label = 'Late';
        backgroundColor = orangeColor.withOpacity(0.1);
        textColor = orangeColor;
        break;
      case ScheduleStatus.absent:
        label = 'Absent';
        backgroundColor = redColor.withOpacity(0.1);
        textColor = redColor;
        break;
      case ScheduleStatus.off:
        label = 'Off';
        backgroundColor = lightGreyColor.withOpacity(0.3);
        textColor = greyColor;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: mediumTextStyle.copyWith(fontSize: 11, color: textColor),
      ),
    );
  }
}
