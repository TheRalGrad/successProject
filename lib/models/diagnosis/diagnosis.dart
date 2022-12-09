import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:telekonsul/models/queue/queue.dart';

part 'diagnosis.g.dart';

@JsonSerializable()
class Diagnosis {
  @JsonKey(name: "doc_id")
  String? docId;

  @JsonKey(name: "queue_data")
  Queue? queueData;

  @JsonKey(name: "diagnosis")
  String? diagnosis;

  @JsonKey(name: "created_at", fromJson: _fromJson, toJson: _toJson)
  late DateTime createdAt;

  Diagnosis();

  factory Diagnosis.fromJson(Map<String, dynamic> json) =>
      _$DiagnosisFromJson(json);
  Map<String, dynamic> toJson() => _$DiagnosisToJson(this);

  static DateTime _fromJson(Timestamp timestamp) => timestamp.toDate();

  static Timestamp _toJson(DateTime dateTime) => Timestamp.fromDate(dateTime);
}
