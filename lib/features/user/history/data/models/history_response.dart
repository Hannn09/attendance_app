import 'package:attendance_cnn_app/features/user/history/domain/models/history_data.dart';

class HistoryResponse {
  final String? message;
  final bool? success;
  final List<History> data;

  HistoryResponse({this.message, this.success, required this.data});

  factory HistoryResponse.fromJson(Map<String, dynamic> json) {
    return HistoryResponse(
      message: json['message'],
      success: json['success'],
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => History.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
