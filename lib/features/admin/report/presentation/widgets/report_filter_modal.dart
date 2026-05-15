import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportFilterModal extends StatefulWidget {
  const ReportFilterModal({super.key});

  @override
  State<ReportFilterModal> createState() => _ReportFilterModalState();

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ReportFilterModal(),
    );
  }
}

class _ReportFilterModalState extends State<ReportFilterModal> {
  late DateTime startDate;
  late DateTime endDate;
  String selectedReportType = 'All Attendance Logs';

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now().subtract(Duration(days: 30));
    endDate = DateTime.now();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 24),
            _buildDateRangeSection(),
            SizedBox(height: 20),
            _buildReportTypeSection(),
            Spacer(),
            _buildExportButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Filter Report', style: boldTextStyle.copyWith(fontSize: 20)),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.close, size: 24),
        ),
      ],
    );
  }

  Widget _buildDateRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date Range', style: mediumTextStyle.copyWith(fontSize: 14)),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildDatePicker(
                'Start Date',
                startDate,
                () => _selectStartDate(context),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildDatePicker(
                'End Date',
                endDate,
                () => _selectEndDate(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label, DateTime date, VoidCallback onDateTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: regularTextStyle.copyWith(fontSize: 12, color: greyColor),
        ),
        SizedBox(height: 4),
        GestureDetector(
          onTap: onDateTap,
          child: Container(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MM/dd/yyyy').format(date),
                  style: regularTextStyle,
                ),
                Icon(Icons.calendar_month, color: greyColor, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReportTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Report Type', style: mediumTextStyle.copyWith(fontSize: 14)),
        SizedBox(height: 8),
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedReportType,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: greyColor),
              items:
                  [
                        'All Attendance Logs',
                        'Present Report',
                        'Absent Report',
                        'Late Report',
                      ]
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type, style: regularTextStyle),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedReportType = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExportButton() {
    return GestureDetector(
      onTap: () {}, // To be implemented later
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.download, color: whiteColor, size: 20),
            SizedBox(width: 8),
            Text(
              'Export Report',
              style: boldTextStyle.copyWith(fontSize: 16, color: whiteColor),
            ),
          ],
        ),
      ),
    );
  }
}
