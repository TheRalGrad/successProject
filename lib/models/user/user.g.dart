part of 'user.dart';

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel()
    ..uid = json['doc_id'] as String?
    ..name = json['name'] as String?
    ..email = json['email'] as String?
    ..phoneNumber = json['phone_number'] as String?
    ..address = json['address'] as String?
    ..profileUrl = json['profile_url'] as String?;
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'doc_id': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'address': instance.address,
      'profile_url': instance.profileUrl,
    };
