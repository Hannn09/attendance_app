class ScheduleRequest {
  final String? date;
  final String? shiftName;

  ScheduleRequest({this.date, this.shiftName});

  Map<String, dynamic> toJson() => {'date': date, 'shift_name': shiftName};
}
