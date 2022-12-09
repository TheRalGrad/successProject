import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:telekonsul/models/consultation_schedule/work_schedule.dart';
import 'package:telekonsul/models/admin/admin.dart';
import 'package:telekonsul/models/user/user.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel {
  @JsonKey(name: "doc_id")
  String? docId;

  @JsonKey(name: "admin_profile")
  Doctor? adminProfile;

  @JsonKey(name: "consultation_schedule")
  ConsultationSchedule? consultationSchedule;

  @JsonKey(name: "status")
  String? status;

  @JsonKey(name: "payment_proof")
  String? paymentProof;

  @JsonKey(name: "created_at", fromJson: _fromJson, toJson: _toJson)
  late DateTime createdAt;

  @JsonKey(name: "created_by")
  UserModel? createdBy;

  TransactionModel();

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  static DateTime _fromJson(Timestamp timestamp) => timestamp.toDate();

  static Timestamp _toJson(DateTime dateTime) => Timestamp.fromDate(dateTime);
}
