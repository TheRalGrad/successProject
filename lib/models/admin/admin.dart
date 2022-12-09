import 'package:json_annotation/json_annotation.dart';
import 'package:telekonsul/models/consultation_schedule/work_schedule.dart';

part 'admin.g.dart';

@JsonSerializable()
class Doctor {
  @JsonKey(name: "doc_id")
  String? uid;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "email")
  String? email;

  @JsonKey(name: "phone_number")
  String? phoneNumber;

  @JsonKey(name: "address")
  String? address;

  @JsonKey(name: "gender")
  String? gender;

  @JsonKey(name: "specialist")
  String? specialist;

  @JsonKey(name: "bank_account")
  String? bankAccount;

  @JsonKey(name: "profile_url")
  String? profileUrl;

  @JsonKey(name: "is_busy")
  bool? isBusy;

  Doctor();

  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorToJson(this);
}

class DataDoctor {
  late Doctor admin;

  late List<ConsultationSchedule> consultationSchedule;

  late bool isBooked;

  DataDoctor();
}
