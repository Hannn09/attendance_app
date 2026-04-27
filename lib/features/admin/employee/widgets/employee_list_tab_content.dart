import 'package:attendance_cnn_app/features/admin/employee/widgets/employee_list_item.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmployeeListTabContent extends StatelessWidget {
  const EmployeeListTabContent({super.key});

  static const List<Map<String, String>> dummyEmployees = [
    {
      'name': 'John Doe',
      'email': 'john.doe@company.com',
      'department': 'Engineering',
      'employeeId': 'EMP001',
    },
    {
      'name': 'Jane Smith',
      'email': 'jane.smith@company.com',
      'department': 'Marketing',
      'employeeId': 'EMP002',
    },
    {
      'name': 'Robert Johnson',
      'email': 'robert.j@company.com',
      'department': 'Human Resources',
      'employeeId': 'EMP003',
    },
    {
      'name': 'Emily Williams',
      'email': 'emily.w@company.com',
      'department': 'Finance',
      'employeeId': 'EMP004',
    },
    {
      'name': 'Michael Brown',
      'email': 'michael.b@company.com',
      'department': 'Engineering',
      'employeeId': 'EMP005',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: dummyEmployees.length,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final employee = dummyEmployees[index];
            return EmployeeListItem(
              name: employee['name']!,
              email: employee['email']!,
              department: employee['department']!,
              employeeId: employee['employeeId']!,
              onEdit: () => _handleEdit(context, employee),
              onDelete: () => _handleDelete(context, employee),
            );
          },
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: () => context.push('/add-employee'),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.add, size: 28, color: whiteColor),
            ),
          ),
        ),
      ],
    );
  }

  void _handleEdit(BuildContext context, Map<String, String> employee) {
    context.push('/edit-employee/${employee['employeeId']}');
  }

  void _handleDelete(BuildContext context, Map<String, String> employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'Delete Employee',
          style: semiBoldTextStyle.copyWith(fontSize: 18, color: blackColor),
        ),
        content: Text(
          'Are you sure you want to delete ${employee['name']}?',
          style: regularTextStyle.copyWith(fontSize: 14, color: greyColor),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Cancel',
              style: mediumTextStyle.copyWith(color: greyColor),
            ),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Employee deleted successfully',
                    style: mediumTextStyle.copyWith(color: whiteColor),
                  ),
                  backgroundColor: greenColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              'Delete',
              style: mediumTextStyle.copyWith(color: redColor),
            ),
          ),
        ],
      ),
    );
  }
}
