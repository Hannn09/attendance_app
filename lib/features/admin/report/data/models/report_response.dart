import 'package:attendance_cnn_app/features/admin/report/domain/models/report_list.dart';

class ReportResponse {
  final bool? success;
  final String? message;
  final List<ReportList> data;

  ReportResponse({this.success, this.message, required this.data});

  factory ReportResponse.fromJson(Map<String, dynamic> json) {
    return ReportResponse(
      success: json['success'],
      message: json['message'],
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => ReportList.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
