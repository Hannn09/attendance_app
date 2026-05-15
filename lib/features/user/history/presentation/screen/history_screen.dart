import 'package:attendance_cnn_app/features/user/history/domain/models/history_data.dart';
import 'package:attendance_cnn_app/features/user/history/presentation/providers/history_list_notifier.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyListProvider);

    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          backgroundColor: whiteColor,
          color: primaryColor,
          onRefresh: () async {
            await ref.read(historyListProvider.notifier).refetch();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attendance History',
                    style: boldTextStyle.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  _buildStatisticsCards(historyAsync),
                  const SizedBox(height: 30),
                  _buildFilterTabs(),
                  const SizedBox(height: 20),
                  _buildHistoryList(historyAsync),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsCards(AsyncValue<List<History>> historyAsync) {
    return historyAsync.when(
      data: (histories) {
        final total = histories.length;
        final present = histories
            .where((h) =>
                h.status == 'Tepat Waktu' ||
                h.status == 'Present' ||
                h.status == 'Present')
            .length;
        final late = histories
            .where((h) =>
                h.status == 'Terlambat' ||
                h.status == 'Late' ||
                h.status?.toLowerCase().contains('late') == true)
            .length;
        final absent = histories
            .where((h) => h.status == 'Absent' || h.status == 'Alpha')
            .length;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildCardTotalAttendance(total)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    _buildCardInformation('Present', present),
                    const SizedBox(height: 10),
                    _buildCardInformation('Late', late),
                    const SizedBox(height: 10),
                    _buildCardInformation('Absent', absent),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => _buildStatisticsSkeleton(),
      error: (_, __) => _buildStatisticsSkeleton(),
    );
  }

  Widget _buildStatisticsSkeleton() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Skeletonizer(
              enabled: true,
              child: _buildCardTotalAttendance(0),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Skeletonizer(
                  enabled: true,
                  child: _buildCardInformation('Present', 0),
                ),
                const SizedBox(height: 10),
                Skeletonizer(
                  enabled: true,
                  child: _buildCardInformation('Late', 0),
                ),
                const SizedBox(height: 10),
                Skeletonizer(
                  enabled: true,
                  child: _buildCardInformation('Absent', 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Row(
      children: [
        Expanded(
          child: _customRadioButton('All', _selectedFilter == 'All', () {
            setState(() {
              _selectedFilter = 'All';
            });
          }),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: _customRadioButton('Present', _selectedFilter == 'Present',
              () {
            setState(() {
              _selectedFilter = 'Present';
            });
          }),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: _customRadioButton('Late', _selectedFilter == 'Late', () {
            setState(() {
              _selectedFilter = 'Late';
            });
          }),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: _customRadioButton('Absent', _selectedFilter == 'Absent',
              () {
            setState(() {
              _selectedFilter = 'Absent';
            });
          }),
        ),
      ],
    );
  }

  Widget _customRadioButton(
    String title,
    bool isSelected,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected ? primaryColor : lightGreyColor,
          ),
        ),
        child: Text(
          title,
          style: isSelected
              ? mediumTextStyle.copyWith(color: whiteColor)
              : regularTextStyle.copyWith(color: greyColor),
        ),
      ),
    );
  }

  Widget _buildHistoryList(AsyncValue<List<History>> historyAsync) {
    final filteredHistoryAsync = historyAsync.whenData((histories) {
      if (_selectedFilter == 'Present') {
        return histories
            .where((h) =>
                h.status == 'Tepat Waktu' ||
                h.status == 'Present' ||
                h.status == 'Present')
            .toList();
      } else if (_selectedFilter == 'Late') {
        return histories
            .where((h) =>
                h.status == 'Terlambat' ||
                h.status == 'Late' ||
                h.status?.toLowerCase().contains('late') == true)
            .toList();
      } else if (_selectedFilter == 'Absent') {
        return histories
            .where((h) => h.status == 'Absent' || h.status == 'Alpha')
            .toList();
      }
      return histories;
    });

    return filteredHistoryAsync.when(
      data: (histories) {
        if (histories.isEmpty) {
          return _buildEmptyState();
        }
        return Column(
          children: histories.map((history) {
            return _buildHistoryListItem(history);
          }).toList(),
        );
      },
      loading: () => _buildHistoryListSkeleton(),
      error: (error, _) => _buildErrorState(error),
    );
  }

  Widget _buildHistoryListItem(History history) {
    final statusColor = _getStatusColor(history.status);
    final statusBgColor = statusColor.withAlpha(20);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 8),
            blurRadius: 15,
            color: blackColor.withValues(alpha: 0.10),
          ),
        ],
        color: whiteColor,
        border: Border.all(color: dividerColor),
      ),
      child: Row(
        children: [
          _buildCalendarWidget(history.date),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _getDayOfWeekFromDate(history.date),
                      style: boldTextStyle.copyWith(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        _normalizeStatus(history.status),
                        style: mediumTextStyle.copyWith(
                          fontSize: 12,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    if (history.checkInTime != null)
                      _buildChecklogItem(
                        Icons.login_rounded,
                        history.checkInTime!,
                        greenColor,
                      ),
                    if (history.checkInTime != null &&
                        history.checkOutTime != null)
                      const SizedBox(width: 10),
                    if (history.checkOutTime != null)
                      _buildChecklogItem(
                        Icons.logout_rounded,
                        history.checkOutTime!,
                        primaryColor,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarWidget(String? dateString) {
    return Container(
      width: 60,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: greenColor.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            _getDayFromDate(dateString),
            style: boldTextStyle.copyWith(color: greenColor),
          ),
          Text(
            _getMonthFromDate(dateString),
            style: mediumTextStyle.copyWith(color: greenColor),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklogItem(IconData icon, String time, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 12),
        const SizedBox(width: 5),
        Text(
          time,
          style: mediumTextStyle.copyWith(fontSize: 12, color: iconColor),
        ),
      ],
    );
  }

  Widget _buildCardTotalAttendance(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: primaryColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Attendance',
            style: mediumTextStyle.copyWith(color: whiteColor),
          ),
          Text(
            '$count Days',
            style: boldTextStyle.copyWith(
              fontSize: 26,
              color: whiteColor,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardInformation(String title, int count) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 8),
            blurRadius: 15,
            color: blackColor.withValues(alpha: 0.10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 35,
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '$count',
              textAlign: TextAlign.center,
              style: boldTextStyle.copyWith(fontSize: 18, color: whiteColor),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: boldTextStyle.copyWith(color: blackColor)),
              Text(
                'Days',
                style: mediumTextStyle.copyWith(color: greyColor, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryListSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: List.generate(
          5,
          (index) => Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 8),
                  blurRadius: 15,
                  color: blackColor.withValues(alpha: 0.10),
                ),
              ],
              color: whiteColor,
              border: Border.all(color: dividerColor),
            ),
            child: Row(
              children: [
                _buildCalendarWidget('2026-05-14T00:00:00.000000Z'),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Thursday',
                            style: boldTextStyle.copyWith(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: greenColor.withAlpha(20),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'Present',
                              style: mediumTextStyle.copyWith(
                                fontSize: 12,
                                color: greenColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          _buildChecklogItem(
                            Icons.login_rounded,
                            '08:00:00',
                            greenColor,
                          ),
                          const SizedBox(width: 10),
                          _buildChecklogItem(
                            Icons.logout_rounded,
                            '17:00:00',
                            primaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: greyColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No attendance history found',
              style: boldTextStyle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Pull down to refresh',
              style: mediumTextStyle.copyWith(color: greyColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: redColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load history',
              style: boldTextStyle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: mediumTextStyle.copyWith(color: greyColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(historyListProvider.notifier).refetch();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: whiteColor,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  String _getDayFromDate(String? dateString) {
    if (dateString == null) return '--';
    try {
      final date = DateTime.parse(dateString);
      return date.day.toString();
    } catch (e) {
      return '--';
    }
  }

  String _getMonthFromDate(String? dateString) {
    if (dateString == null) return '--';
    try {
      final date = DateTime.parse(dateString);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return months[date.month - 1];
    } catch (e) {
      return '--';
    }
  }

  String _getDayOfWeekFromDate(String? dateString) {
    if (dateString == null) return 'Day';
    try {
      final date = DateTime.parse(dateString);
      const days = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];
      return days[date.weekday - 1];
    } catch (e) {
      return 'Day';
    }
  }

  Color _getStatusColor(String? status) {
    if (status == null) return greyColor;

    final normalizedStatus = _normalizeStatus(status).toLowerCase();

    if (normalizedStatus.contains('present')) {
      return greenColor;
    } else if (normalizedStatus.contains('late')) {
      return orangeColor;
    } else if (normalizedStatus.contains('absent')) {
      return redColor;
    }
    return greyColor;
  }

  String _normalizeStatus(String? status) {
    if (status == null) return 'Unknown';

    final lowerStatus = status.toLowerCase();

    // Map Indonesian to English
    if (lowerStatus.contains('tepat') || lowerStatus.contains('hadir')) {
      return 'Present';
    } else if (lowerStatus.contains('terlambat')) {
      return 'Late';
    } else if (lowerStatus.contains('alpha') || lowerStatus.contains('tidak hadir')) {
      return 'Absent';
    }

    // Already in English or unknown
    if (lowerStatus.contains('present')) return 'Present';
    if (lowerStatus.contains('late')) return 'Late';
    if (lowerStatus.contains('absent')) return 'Absent';

    return status; // Return original if no match
  }
}
