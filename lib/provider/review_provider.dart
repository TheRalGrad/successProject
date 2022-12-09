import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:telekonsul/models/diagnosis/diagnosis.dart';

class DiagnosisProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<Diagnosis> _listDiagnosis = [];
  List<Diagnosis> get listDiagnosis => _listDiagnosis;

  // Get all the diagnosis data from user subCollection
  getAllDiagnosis(String? userUid) async {
    _isLoading = true;
    _listDiagnosis.clear();

    try {
      await FirebaseFirestore.instance
          .doc('users/$userUid')
          .collection('diagnosis')
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        _listDiagnosis
            .addAll(value.docs.map((e) => Diagnosis.fromJson(e.data())));
        _isLoading = false;
        notifyListeners();
        return;
      });
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return;
    }
  }

  // การเพิ่มข้อมูลการรีวิวไปยังคอลเลกชันย่อยของผู้ใช้ subCollection
  addDiagnosis(Map<String, dynamic> data, String? userUid) async {
    _isLoading = true;

    await FirebaseFirestore.instance
        .doc('users/$userUid')
        .collection('diagnosis')
        .add(data)
        .then((value) async {
      await value.update({
        "doc_id": value.id,
      });
    });

    _isLoading = false;
    notifyListeners();
    return;
  }
}
