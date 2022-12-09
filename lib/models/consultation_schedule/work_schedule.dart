import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'work_schedule.g.dart';

@JsonSerializable()
class ConsultationSchedule {
  @JsonKey(name: "doc_id")
  String? docId;

  @JsonKey(name: "day_schedule")
  DaySchedule? daySchedule;

  @JsonKey(name: "month_schedule")
  MonthSchedule? monthSchedule;

  @JsonKey(name: "start_at", fromJson: _fromJson, toJson: _toJson)
  TimeOfDay? startAt;

  @JsonKey(name: "end_at", fromJson: _fromJson, toJson: _toJson)
  TimeOfDay? endAt;

  @JsonKey(name: "price")
  double? price;

  ConsultationSchedule();

  factory ConsultationSchedule.fromJson(Map<String, dynamic> json) =>
      _$ConsultationScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$ConsultationScheduleToJson(this);

  static TimeOfDay _fromJson(String hour) {
    final format = DateFormat.jm();
    return TimeOfDay.fromDateTime(format.parse(hour));
  }

  static String _toJson(TimeOfDay? hour) => hour.toString();
}

@JsonSerializable()
class DaySchedule {
  @JsonKey(name: "day")
  String? day;

  @JsonKey(name: "int_value")
  int? intValue;

  DaySchedule(this.day, this.intValue);

  factory DaySchedule.fromJson(Map<String, dynamic> json) =>
      _$DayScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$DayScheduleToJson(this);
}

@JsonSerializable()
class MonthSchedule {
  @JsonKey(name: "month")
  String? month;

  @JsonKey(name: "int_value1")
  int? intValue1;

  MonthSchedule(this.month, this.intValue1);

  factory MonthSchedule.fromJson(Map<String, dynamic> json) =>
      _$MonthScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$MonthScheduleToJson(this);
}
