import 'package:attendance_cnn_app/features/admin/report/domain/models/report_list.dart';
import 'package:attendance_cnn_app/features/admin/report/presentation/providers/report_list_notifier.dart';
import 'package:attendance_cnn_app/features/admin/report/presentation/widgets/report_filter_modal.dart';
import 'package:attendance_cnn_app/features/admin/report/presentation/widgets/report_filter_radio.dart';
import 'package:attendance_cnn_app/features/admin/report/presentation/widgets/report_list_item.dart';
import 'package:attendance_cnn_app/features/admin/report/presentation/widgets/report_search_bar.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  int _selectedFilterIndex = 0;
  String _searchQuery = '';

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ReportFilterModal(),
    );
  }

  List<ReportList> _filterReports(List<ReportList> reports) {
    var filtered = reports;

    // Apply status filter
    switch (_selectedFilterIndex) {
      case 1: // Present (On Time / hadir)
        filtered = filtered.where((report) => report.status?.toLowerCase() == 'hadir').toList();
        break;
      case 2: // Late (telat)
        filtered = filtered.where((report) => report.status?.toLowerCase() == 'telat').toList();
        break;
      case 3: // Absent (absent)
        filtered = filtered.where((report) => report.status?.toLowerCase() == 'absent').toList();
        break;
      case 0: // All - do nothing
      default:
        break;
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((report) {
        return report.name?.toLowerCase().contains(query) ?? false;
      }).toList();
    }

    return filtered;
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reportListAsync = ref.watch(reportListNotifierProvider);

    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReportSearchBar(
                    onFilterTap: _showFilterModal,
                    onSearchChanged: _onSearchChanged,
                  ),
                  SizedBox(height: 20),
                  ReportFilterRadio(
                    selectedIndex: _selectedFilterIndex,
                    onFilterChanged: (index) {
                      setState(() {
                        _selectedFilterIndex = index;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: reportListAsync.when(
                data: (reports) {
                  if (reports.isEmpty) {
                    return _buildEmptyState();
                  }

                  final filteredReports = _filterReports(reports);

                  if (filteredReports.isEmpty) {
                    return _buildEmptyFilteredState();
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    itemCount: filteredReports.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return ReportListItem(report: filteredReports[index]);
                    },
                  );
                },
                loading: () => _buildSkeletonLoader(),
                error: (error, stack) => _buildErrorState(error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Skeletonizer(
      enabled: true,
      enableSwitchAnimation: true,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 25),
        itemCount: 5,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          return ReportListItem(
            report: ReportList(
              name: 'Employee Name',
              status: 'hadir',
              checkInTime: '2026-05-14T07:48:00.000000Z',
              checkOutTime: '2026-05-14T17:00:00.000000Z',
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.withAlpha(50)),
          SizedBox(height: 16),
          Text(
            'Failed to load reports',
            style: semiBoldTextStyle.copyWith(fontSize: 16),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: mediumTextStyle.copyWith(color: greyColor),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                ref.read(reportListNotifierProvider.notifier).refetch(),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: whiteColor,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assessment_outlined,
            size: 64,
            color: greyColor.withAlpha(50),
          ),
          SizedBox(height: 16),
          Text(
            'No reports found',
            style: semiBoldTextStyle.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFilteredState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.filter_list_off,
            size: 64,
            color: greyColor.withAlpha(50),
          ),
          SizedBox(height: 16),
          Text(
            'No reports match this filter',
            style: semiBoldTextStyle.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
