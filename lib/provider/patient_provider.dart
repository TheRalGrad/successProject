import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:telekonsul/models/user/user.dart';

class PatientProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<UserModel> _patient = [];
  List<UserModel> get patient => _patient;

  final List<UserModel> _listAllPatient = [];
  List<UserModel> get listAllPatient => _listAllPatient;

  // การเพิ่มข้อมูลผู้ป่วยไปยังคอลเลคชันย่อยของแพทย์ด้วยรหัสเดียวกันกับผู้ใช้
  // ดังนั้นจึงง่ายต่อการตรวจสอบว่ามีเอกสารอยู่แล้วหรือไม่ เพื่อป้องกันการซ้ำซ้อน
  addPatient(String? uid, Map<String, dynamic> data) async {
    final dataPatient = await FirebaseFirestore.instance
        .doc('admin/$uid/patient/${data['doc_id']}')
        .get();

    if (dataPatient.exists) {
      return;
    }

    await FirebaseFirestore.instance
        .doc('admin/$uid/patient/${data['doc_id']}')
        .set(data);
  }

  get7Patient(String uid) async {
    _isLoading = true;
    _patient.clear();
    FirebaseFirestore.instance
        .doc('admin/$uid')
        .collection('patient')
        .limit(7)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      _patient.addAll(value.docs.map((e) => UserModel.fromJson(e.data())));
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  getAllPatient(String? uid) async {
    _isLoading = true;
    _listAllPatient.clear();
    FirebaseFirestore.instance
        .doc('admin/$uid')
        .collection('patient')
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      _listAllPatient
          .addAll(value.docs.map((e) => UserModel.fromJson(e.data())));
      _isLoading = false;
      notifyListeners();
      return;
    });
  }
}
