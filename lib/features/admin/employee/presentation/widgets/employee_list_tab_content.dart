import 'package:attendance_cnn_app/core/domain/models/employee_model.dart';
import 'package:attendance_cnn_app/features/admin/employee/presentation/providers/employee_action_notifier.dart';
import 'package:attendance_cnn_app/features/admin/employee/presentation/providers/employee_list_notifier.dart';
import 'package:attendance_cnn_app/features/admin/employee/presentation/widgets/employee_list_item.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EmployeeListTabContent extends ConsumerWidget {
  const EmployeeListTabContent({super.key});

  static const int _skeletonItemCount = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeState = ref.watch(employeeListNotifierProvider);

    // EmployeeListTabContent - ref.listen
    ref.listen(employeeActionNotifierProvider, (previous, next) async {
      if (next.hasValue &&
          previous != null &&
          previous.isLoading &&
          context.mounted) {
        if (next.value == null) {
          await ScaffoldMessenger.of(context)
              .showSnackBar(
                SnackBar(
                  content: Text(
                    'Employee deleted successfully',
                    style: mediumTextStyle.copyWith(color: whiteColor),
                  ),
                  backgroundColor: greenColor,
                ),
              )
              .closed;
        }
        ref.read(employeeActionNotifierProvider.notifier).reset();
        ref.invalidate(employeeListNotifierProvider);
      } else if (next.hasError && context.mounted) {
        if (next.value == null) {
          await ScaffoldMessenger.of(context)
              .showSnackBar(
                SnackBar(
                  content: Text(
                    next.error.toString(),
                    style: mediumTextStyle.copyWith(color: whiteColor),
                  ),
                  backgroundColor: redColor,
                  behavior: SnackBarBehavior.floating,
                ),
              )
              .closed;
          ref.read(employeeActionNotifierProvider.notifier).reset();
        }
      }
    });

    return Stack(
      children: [
        employeeState.when(
          loading: () => _buildSkeletonLoader(),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: redColor),
                SizedBox(height: 16),
                Text(
                  'Failed to load employees',
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
              ],
            ),
          ),
          data: (employees) {
            if (employees.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_outline, size: 48, color: greyColor),
                    SizedBox(height: 16),
                    Text(
                      'No employees found',
                      style: semiBoldTextStyle.copyWith(
                        fontSize: 16,
                        color: blackColor,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: employees.length,
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final employee = employees[index];
                return EmployeeListItem(
                  username: employee.username,
                  fullname: employee.name,
                  role: employee.role ?? '-',
                  onEdit: () => _handleEdit(context, employee),
                  onDelete: () => _handleDelete(context, ref, employee),
                );
              },
            );
          },
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
        physics: NeverScrollableScrollPhysics(),
        itemCount: _skeletonItemCount,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          return EmployeeListItem(
            username: 'username',
            fullname: 'Employee Name',
            role: 'Role',
          );
        },
      ),
    );
  }

  void _handleEdit(BuildContext context, EmployeeModel employee) {
    context.push('/edit-employee/${employee.id}');
  }

  void _handleDelete(
    BuildContext context,
    WidgetRef ref,
    EmployeeModel employee,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'Delete Employee',
          style: semiBoldTextStyle.copyWith(fontSize: 18, color: blackColor),
        ),
        content: Text(
          'Are you sure you want to delete ${employee.name}?',
          style: regularTextStyle.copyWith(fontSize: 14, color: greyColor),
        ),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(),
            child: Text(
              'Cancel',
              style: mediumTextStyle.copyWith(color: greyColor),
            ),
          ),
          TextButton(
            onPressed: () {
              dialogContext.pop();
              ref
                  .read(employeeActionNotifierProvider.notifier)
                  .deleteEmployee(employee.id);
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
