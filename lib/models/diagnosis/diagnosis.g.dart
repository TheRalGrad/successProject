part of 'diagnosis.dart';

Diagnosis _$DiagnosisFromJson(Map<String, dynamic> json) {
  return Diagnosis()
    ..docId = json['doc_id'] as String?
    ..queueData = json['queue_data'] == null
        ? null
        : Queue.fromJson(json['queue_data'] as Map<String, dynamic>)
    ..diagnosis = json['diagnosis'] as String?
    ..createdAt = Diagnosis._fromJson(json['created_at'] as Timestamp);
}

Map<String, dynamic> _$DiagnosisToJson(Diagnosis instance) => <String, dynamic>{
      'doc_id': instance.docId,
      'queue_data': instance.queueData,
      'diagnosis': instance.diagnosis,
      'created_at': Diagnosis._toJson(instance.createdAt),
    };
