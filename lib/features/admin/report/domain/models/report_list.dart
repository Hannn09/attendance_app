class ReportList {
  final int? userId;
  final String? name;
  final String? status;
  final String? checkInTime;
  final String? checkOutTime;
  final double? checkInLatitude;
  final double? checkInLongitude;
  final double? checkOutLatitude;
  final double? checkOutLongitude;

  ReportList({
    this.userId,
    this.name,
    this.status,
    this.checkInTime,
    this.checkOutTime,
    this.checkInLatitude,
    this.checkInLongitude,
    this.checkOutLatitude,
    this.checkOutLongitude,
  });

  factory ReportList.fromJson(Map<String, dynamic> json) {
    return ReportList(
      userId: json['user_id'],
      name: json['name'],
      status: json['status'],
      checkInTime: json['checkin_time'] as String?,
      checkOutTime: json['checkout_time'] as String?,
      checkInLatitude: json['checkin_latitude'] as double?,
      checkInLongitude: json['checkin_longitude'] as double?,
      checkOutLatitude: json['checkout_latitude'] as double?,
      checkOutLongitude: json['checkout_longitude'] as double?,
    );
  }
}
