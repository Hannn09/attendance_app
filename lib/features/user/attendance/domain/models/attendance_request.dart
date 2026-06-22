import 'dart:io';

class AttendanceRequest {
  final int userId;
  final String note;
  final String latitude;
  final String longitude;
  final File photoFile;

  AttendanceRequest({
    required this.userId,
    required this.note,
    required this.latitude,
    required this.longitude,
    required this.photoFile,
  });
}
