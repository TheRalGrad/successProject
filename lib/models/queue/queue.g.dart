part of 'queue.dart';

Queue _$QueueFromJson(Map<String, dynamic> json) {
  return Queue()
    ..docId = json['doc_id'] as String?
    ..transactionData = json['transaction_data'] == null
        ? null
        : TransactionModel.fromJson(
            json['transaction_data'] as Map<String, dynamic>)
    ..queueNumber = json['queue_number'] as int?
    ..isDone = json['is_done'] as bool?
    ..createdAt = Queue._fromJson(json['created_at'] as Timestamp);
}

Map<String, dynamic> _$QueueToJson(Queue instance) => <String, dynamic>{
      'doc_id': instance.docId,
      'transaction_data': instance.transactionData,
      'queue_number': instance.queueNumber,
      'is_done': instance.isDone,
      'created_at': Queue._toJson(instance.createdAt),
    };
