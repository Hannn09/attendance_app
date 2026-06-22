import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportFilterModal extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime startDate, DateTime endDate)? onApply;
  final VoidCallback? onReset;

  const ReportFilterModal({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    this.onApply,
    this.onReset,
  });

  @override
  State<ReportFilterModal> createState() => _ReportFilterModalState();

  static void show(
    BuildContext context, {
    DateTime? initialStartDate,
    DateTime? initialEndDate,
    Function(DateTime startDate, DateTime endDate)? onApply,
    VoidCallback? onReset,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReportFilterModal(
        initialStartDate: initialStartDate,
        initialEndDate: initialEndDate,
        onApply: onApply,
        onReset: onReset,
      ),
    );
  }
}

class _ReportFilterModalState extends State<ReportFilterModal> {
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    startDate =
        widget.initialStartDate ??
        DateTime.now().subtract(const Duration(days: 30));
    endDate = widget.initialEndDate ?? DateTime.now();
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
            Spacer(),
            _buildActionButtons(),
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              widget.onReset?.call();
              Navigator.pop(context);
            },
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh, color: primaryColor, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Reset',
                    style: boldTextStyle.copyWith(
                      fontSize: 16,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () {
              widget.onApply?.call(startDate, endDate);
              Navigator.pop(context);
            },
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check, color: whiteColor, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Apply',
                    style: boldTextStyle.copyWith(
                      fontSize: 16,
                      color: whiteColor,
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
}
