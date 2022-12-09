import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:telekonsul/models/transaction/transaction_model.dart';

part 'queue.g.dart';

@JsonSerializable()
class Queue {
  @JsonKey(name: "doc_id")
  String? docId;

  @JsonKey(name: "transaction_data")
  TransactionModel? transactionData;

  @JsonKey(name: "queue_number")
  int? queueNumber;

  @JsonKey(name: "is_done")
  bool? isDone;

  @JsonKey(name: "created_at", fromJson: _fromJson, toJson: _toJson)
  late DateTime createdAt;

  Queue();

  factory Queue.fromJson(Map<String, dynamic> json) => _$QueueFromJson(json);
  Map<String, dynamic> toJson() => _$QueueToJson(this);

  static DateTime _fromJson(Timestamp timestamp) => timestamp.toDate();

  static Timestamp _toJson(DateTime dateTime) => Timestamp.fromDate(dateTime);
}
