class ReportList {
  final int? userId;
  final String? name;
  final String? status;
  final String? checkInTime;
  final String? checkOutTime;

  ReportList({
    this.userId,
    this.name,
    this.status,
    this.checkInTime,
    this.checkOutTime,
  });

  factory ReportList.fromJson(Map<String, dynamic> json) {
    return ReportList(
      userId: json['user_id'],
      name: json['name'],
      status: json['status'],
      checkInTime: json['checkin_time'] as String?,
      checkOutTime: json['checkout_time'] as String?,
    );
  }
}
