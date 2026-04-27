import 'package:attendance_cnn_app/features/admin/employee/models/shift_type.dart';
import 'package:attendance_cnn_app/features/admin/employee/widgets/schedule_date_selector.dart';
import 'package:attendance_cnn_app/features/admin/employee/widgets/schedule_employee_card.dart';
import 'package:attendance_cnn_app/features/admin/employee/widgets/shift_selection_modal.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';

class ScheduleTabContent extends StatefulWidget {
  const ScheduleTabContent({super.key});

  @override
  State<ScheduleTabContent> createState() => _ScheduleTabContentState();
}

class _ScheduleTabContentState extends State<ScheduleTabContent> {
  DateTime _selectedDate = DateTime.now();
  ShiftType? _selectedFilter;

  // Map to store schedules: key = employeeId, value = map of date -> shiftType
  final Map<String, Map<String, ShiftType>> _employeeSchedules = {};

  // Dummy employee data
  static const List<Map<String, dynamic>> dummyEmployees = [
    {
      'id': '1',
      'employeeName': 'John Doe',
      'shiftType': 'Morning',
      'startTime': '08:00',
      'endTime': '17:00',
      'workingDays': [1, 2, 3, 4, 5],
    },
    {
      'id': '2',
      'employeeName': 'Jane Smith',
      'shiftType': 'Afternoon',
      'startTime': '14:00',
      'endTime': '23:00',
      'workingDays': [1, 2, 3, 4, 5],
    },
    {
      'id': '3',
      'employeeName': 'Robert Johnson',
      'shiftType': 'Night',
      'startTime': '22:00',
      'endTime': '07:00',
      'workingDays': [1, 2, 3, 4, 5, 6],
    },
    {
      'id': '4',
      'employeeName': 'Emily Williams',
      'shiftType': 'Morning',
      'startTime': '09:00',
      'endTime': '18:00',
      'workingDays': [1, 2, 3, 4, 5],
    },
    {
      'id': '5',
      'employeeName': 'Michael Brown',
      'shiftType': 'Afternoon',
      'startTime': '13:00',
      'endTime': '22:00',
      'workingDays': [2, 3, 4, 5, 6],
    },
    {
      'id': '6',
      'employeeName': 'Sarah Davis',
      'shiftType': 'Night',
      'startTime': '21:00',
      'endTime': '06:00',
      'workingDays': [1, 2, 3, 4, 5],
    },
    {
      'id': '7',
      'employeeName': 'David Wilson',
      'shiftType': 'Morning',
      'startTime': '08:00',
      'endTime': '17:00',
      'workingDays': [1, 2, 3, 4, 5],
    },
    {
      'id': '8',
      'employeeName': 'Lisa Martinez',
      'shiftType': 'Afternoon',
      'startTime': '14:00',
      'endTime': '23:00',
      'workingDays': [1, 2, 3, 4, 5, 6],
    },
  ];

  // Initialize employee schedules
  @override
  void initState() {
    super.initState();
    _initializeSchedules();
  }

  void _initializeSchedules() {
    for (var employee in dummyEmployees) {
      final employeeId = employee['id'] as String;
      _employeeSchedules[employeeId] = {
        _getDateKey(DateTime.now()): ShiftTypeExtension.fromString(
          employee['shiftType'] as String,
        ),
      };
    }
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  ShiftType _getEmployeeShift(String employeeId, DateTime date) {
    final dateKey = _getDateKey(date);
    if (_employeeSchedules[employeeId]?.containsKey(dateKey) == true) {
      return _employeeSchedules[employeeId]![dateKey]!;
    }
    // Default shift if not set
    return ShiftType.pagi;
  }

  void _updateEmployeeShift(
    String employeeId,
    DateTime date,
    ShiftType newShift,
  ) {
    final dateKey = _getDateKey(date);
    setState(() {
      if (_employeeSchedules[employeeId] == null) {
        _employeeSchedules[employeeId] = {};
      }
      _employeeSchedules[employeeId]![dateKey] = newShift;
    });
  }

  List<Map<String, dynamic>> get _filteredEmployees {
    var employees = dummyEmployees;

    if (_selectedFilter != null) {
      employees = employees.where((employee) {
        final employeeId = employee['id'] as String;
        final shift = _getEmployeeShift(employeeId, _selectedDate);
        return shift == _selectedFilter;
      }).toList();
    }

    return employees;
  }

  void _showShiftModal(
    String employeeId,
    String employeeName,
    ShiftType currentShift,
  ) {
    ShiftSelectionModal.show(
      context,
      employeeName: employeeName,
      currentShift: currentShift,
      onShiftSelected: (newShift) {
        _updateEmployeeShift(employeeId, _selectedDate, newShift);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScheduleDateSelector(
          selectedDate: _selectedDate,
          onDateChanged: (date) => setState(() => _selectedDate = date),
        ),
        SizedBox(height: 20),
        _buildFilterTabs(),
        SizedBox(height: 20),
        _buildEmployeeList(),
      ],
    );
  }

  Widget _buildFilterTabs() {
    final filters = [null, ...ShiftType.values];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (context, index) => SizedBox(width: 12),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
            child: Container(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? primaryColor : borderColor,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (filter != null) ...[
                    Text(filter.emoji, style: TextStyle(fontSize: 14)),
                    SizedBox(width: 4),
                  ],
                  Text(
                    filter?.displayName ?? 'All',
                    style: mediumTextStyle.copyWith(
                      fontSize: 13,
                      color: isSelected ? whiteColor : greyColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmployeeList() {
    // Calculate available height for the list using MediaQuery
    final screenHeight = MediaQuery.of(context).size.height;
    final safePadding = MediaQuery.of(context).padding.vertical;
    final topPadding = 25.0; // From EmployeeScreen padding
    final tabBarHeight = 50.0; // Approximate
    final spacerHeight = 35.0; // Spacer in EmployeeScreen
    final dateSelectorHeight = 70.0; // ScheduleDateSelector
    final filterHeight = 40.0; // Filter tabs
    final gapsHeight = 40.0; // Two 20px gaps
    final listHeight =
        screenHeight -
        safePadding -
        topPadding -
        tabBarHeight -
        spacerHeight -
        dateSelectorHeight -
        filterHeight -
        gapsHeight;

    return SizedBox(
      height: listHeight > 0 ? listHeight : 400,
      child: ListView.builder(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
        itemExtent: 130,
        itemCount: _filteredEmployees.length,
        itemBuilder: (context, index) {
          final employee = _filteredEmployees[index];
          final employeeId = employee['id'] as String;
          final shiftType = _getEmployeeShift(employeeId, _selectedDate);

          return Padding(
            padding: EdgeInsetsGeometry.only(bottom: 12),
            child: ScheduleEmployeeCard(
              key: ValueKey('${employeeId}_${_getDateKey(_selectedDate)}'),
              employeeName: employee['employeeName'] as String,
              shiftType: shiftType,
              startTime: shiftType.startTime,
              endTime: shiftType.endTime,
              workingDays: List<int>.from(employee['workingDays'] as List),
              onShiftTap: () => _showShiftModal(
                employeeId,
                employee['employeeName'] as String,
                shiftType,
              ),
            ),
          );
        },
      ),
    );
  }
}
