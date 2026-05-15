class ScheduleList {
  final int? scheduleId;
  final int? userId;
  final String? name;
  final String? shiftName;

  ScheduleList({this.scheduleId, this.userId, this.name, this.shiftName});

  factory ScheduleList.fromJson(Map<String, dynamic> json) {
    return ScheduleList(
      scheduleId: json['schedule_id'] as int?,
      userId: json['user_id'] as int?,
      name: json['name'] as String?,
      shiftName: json['shift_name'] as String?,
    );
  }
}
