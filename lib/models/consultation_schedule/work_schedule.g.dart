part of 'work_schedule.dart';

ConsultationSchedule _$ConsultationScheduleFromJson(Map<String, dynamic> json) {
  return ConsultationSchedule()
    ..docId = json['doc_id'] as String?
    ..daySchedule = json['day_schedule'] == null
        ? null
        : DaySchedule.fromJson(json['day_schedule'] as Map<String, dynamic>)
    ..monthSchedule = json['month_schedule'] == null
        ? null
        : MonthSchedule.fromJson(json['month_schedule'] as Map<String, dynamic>)
    ..startAt = ConsultationSchedule._fromJson(json['start_at'] as String)
    ..endAt = ConsultationSchedule._fromJson(json['end_at'] as String)
    ..price = (json['price'] as num?)?.toDouble();
}

Map<String, dynamic> _$ConsultationScheduleToJson(
        ConsultationSchedule instance) =>
    <String, dynamic>{
      'doc_id': instance.docId,
      'day_schedule': instance.daySchedule,
      'dmonth_schedule': instance.monthSchedule,
      'start_at': ConsultationSchedule._toJson(instance.startAt),
      'end_at': ConsultationSchedule._toJson(instance.endAt),
      'price': instance.price,
    };

DaySchedule _$DayScheduleFromJson(Map<String, dynamic> json) {
  return DaySchedule(
    json['day'] as String?,
    json['int_value'] as int?,
  );
}

MonthSchedule _$MonthScheduleFromJson(Map<String, dynamic> json) {
  return MonthSchedule(
    json['month'] as String?,
    json['int_value1'] as int?,
  );
}

Map<String, dynamic> _$DayScheduleToJson(DaySchedule instance) =>
    <String, dynamic>{
      'day': instance.day,
      'int_value': instance.intValue,
    };

Map<String, dynamic> _$MonthScheduleToJson(MonthSchedule instance) =>
    <String, dynamic>{
      'month': instance.month,
      'int_value1': instance.intValue1,
    };
