class DashboardData {
  final int totalEmployee;
  final int totalNotCheckIn;
  final int totalAbsent;
  final int totalLate;
  final int totalOnTime;

  DashboardData({
    required this.totalEmployee,
    required this.totalNotCheckIn,
    required this.totalAbsent,
    required this.totalLate,
    required this.totalOnTime,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      totalEmployee: json['total_employees'] as int,
      totalNotCheckIn: json['not_checked_in'] as int,
      totalAbsent: json['absent_today'] as int,
      totalLate: json['late_today'] as int,
      totalOnTime: json['on_time_today'] as int,
    );
  }
}
