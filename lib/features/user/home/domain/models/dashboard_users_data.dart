class DashboardUsersData {
  final int? presentCount;
  final int? absentCount;
  final int? overtimeCount;
  final int? lateCount;

  DashboardUsersData({
    this.presentCount,
    this.absentCount,
    this.overtimeCount,
    this.lateCount,
  });

  factory DashboardUsersData.fromJson(Map<String, dynamic> json) {
    return DashboardUsersData(
      presentCount: json['present'],
      absentCount: json['absent'],
      overtimeCount: json['overtime'],
      lateCount: json['late'],
    );
  }
}
