import 'package:attendance_cnn_app/features/admin/report/widgets/report_filter_modal.dart';
import 'package:attendance_cnn_app/features/admin/report/widgets/report_filter_radio.dart';
import 'package:attendance_cnn_app/features/admin/report/widgets/report_list_item.dart';
import 'package:attendance_cnn_app/features/admin/report/widgets/report_search_bar.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int _selectedFilterIndex = 0;

  final List<Map<String, dynamic>> dummyReports = [
    {
      'id': '1',
      'employeeName': 'Ahmad Dahlan',
      'initials': 'AD',
      'checkIn': '07:45 AM',
      'checkOut': '05:00 PM',
      'status': 'ON TIME',
      'date': '2024-04-19',
    },
    {
      'id': '2',
      'employeeName': 'Siti Khadijah',
      'initials': 'SK',
      'checkIn': '07:55 AM',
      'checkOut': '--:--',
      'status': 'LATE',
      'date': '2024-04-19',
    },
    {
      'id': '3',
      'employeeName': 'Budi Santoso',
      'initials': 'BS',
      'checkIn': '--:--',
      'checkOut': '--:--',
      'status': 'ABSENT',
      'date': '2024-04-19',
    },
    {
      'id': '4',
      'employeeName': 'Rina Wijaya',
      'initials': 'RW',
      'checkIn': '07:30 AM',
      'checkOut': '05:15 PM',
      'status': 'ON TIME',
      'date': '2024-04-19',
    },
    {
      'id': '5',
      'employeeName': 'Doni Pratama',
      'initials': 'DP',
      'checkIn': '08:15 AM',
      'checkOut': '--:--',
      'status': 'LATE',
      'date': '2024-04-19',
    },
  ];

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ReportFilterModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  ReportSearchBar(onFilterTap: _showFilterModal),
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: ListView.separated(
                  itemCount: dummyReports.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12),
                  itemBuilder: (context, index) =>
                      ReportListItem(report: dummyReports[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
