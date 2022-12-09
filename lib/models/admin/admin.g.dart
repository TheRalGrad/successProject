part of 'admin.dart';

Doctor _$DoctorFromJson(Map<String, dynamic> json) {
  return Doctor()
    ..uid = json['doc_id'] as String?
    ..name = json['name'] as String?
    ..email = json['email'] as String?
    ..phoneNumber = json['phone_number'] as String?
    ..address = json['address'] as String?
    ..gender = json['gender'] as String?
    ..specialist = json['specialist'] as String?
    ..bankAccount = json['bank_account'] as String?
    ..profileUrl = json['profile_url'] as String?
    ..isBusy = json['is_busy'] as bool?;
}

Map<String, dynamic> _$DoctorToJson(Doctor instance) => <String, dynamic>{
      'doc_id': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'address': instance.address,
      'gender': instance.gender,
      'specialist': instance.specialist,
      'bank_account': instance.bankAccount,
      'profile_url': instance.profileUrl,
      'is_busy': instance.isBusy,
    };
