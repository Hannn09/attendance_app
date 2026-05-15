class History {
  final int? id;
  final int? userId;
  final String? date;
  final String? checkInTime;
  final String? checkOutTime;
  final String? checkInPhoto;
  final String? checkOutPhoto;
  final String? status;
  final bool? isOvertime;
  final double? latitude;
  final double? longitude;
  final String? createdAt;
  final String? updatedAt;

  History({
    this.id,
    this.userId,
    this.date,
    this.checkInTime,
    this.checkOutTime,
    this.checkInPhoto,
    this.checkOutPhoto,
    this.status,
    this.isOvertime,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'],
      userId: json['user_id'],
      date: json['date'],
      checkInTime: json['check_in_time'],
      checkOutTime: json['check_out_time'],
      checkInPhoto: json['check_in_photo'],
      checkOutPhoto: json['check_out_photo'],
      status: json['status'],
      isOvertime: json['is_overtime'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date,
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'check_in_photo': checkInPhoto,
      'check_out_photo': checkOutPhoto,
      'status': status,
      'is_overtime': isOvertime,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
