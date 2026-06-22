class AttendanceData {
  final int? id;
  final int? userId;
  final String? date;
  final String? checkInTime;
  final String? checkOutTime;
  final String? checkInPhoto;
  final String? checkOutPhoto;
  final double? latitude;
  final double? longitude;
  final String? status;
  final bool? isOvertime;
  final String? createdAt;
  final String? updatedAt;

  AttendanceData({
    this.id,
    this.userId,
    this.date,
    this.checkInTime,
    this.checkOutTime,
    this.checkInPhoto,
    this.checkOutPhoto,
    this.latitude,
    this.longitude,
    this.status,
    this.isOvertime,
    this.createdAt,
    this.updatedAt,
  });

  factory AttendanceData.fromMap(Map<String, dynamic> map) {
    return AttendanceData(
      id: map['id'] as int?,
      userId: map['user_id'] as int?,
      date: map['date'] as String?,
      checkInTime: map['check_in_time'] as String?,
      checkOutTime: map['check_out_time'] as String?,
      checkInPhoto: map['check_in_photo'] as String?,
      checkOutPhoto: map['check_out_photo'] as String?,
      latitude: map['latitude'] as double?,
      longitude: map['longitude'] as double?,
      status: map['status'] as String?,
      isOvertime: map['is_overtime'] as bool?,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
    );
  }
}
