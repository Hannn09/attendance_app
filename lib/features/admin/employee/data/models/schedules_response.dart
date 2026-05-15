import 'package:attendance_cnn_app/features/admin/employee/domain/models/schedule_list.dart';

class SchedulesResponse {
  final bool? success;
  final List<ScheduleList>? data;

  SchedulesResponse({this.success, this.data});

  factory SchedulesResponse.fromJson(Map<String, dynamic> json) {
    return SchedulesResponse(
      success: json['success'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ScheduleList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
