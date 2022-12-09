import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:telekonsul/models/consultation_schedule/work_schedule.dart';

class ConsultationScheduleProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<ConsultationSchedule> _listConsultationSchedule = [];
  List<ConsultationSchedule> get listConsultationSchedule =>
      _listConsultationSchedule;

  // รับข้อมูล work schedule ทั้งหมดจาก Admin subCollection
  getListConsultationSchedule(String? adminId) async {
    _isLoading = true;
    _listConsultationSchedule.clear();
    await FirebaseFirestore.instance
        .doc('admin/$adminId')
        .collection('consultation_schedule')
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      _listConsultationSchedule.addAll(
          value.docs.map((e) => ConsultationSchedule.fromJson(e.data())));
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  // การเพิ่มข้อมูลกำหนดการให้งานไปยังคอลเลคชันย่อยของ แอดมิน  subCollection
  addConsultationSchedule(
    Map<String, dynamic> data,
    String? adminId,
  ) async {
    await FirebaseFirestore.instance
        .doc("admin/$adminId")
        .collection('consultation_schedule')
        .add(data)
        .then((value) async {
      await value.update({
        'doc_id': value.id,
      });
      return;
    });
  }

  // อัพเดทข้อมูลตารางการปรึกษาแพทย์
  updateConsultationSchedule(
    String? docId,
    Map<String, dynamic> data,
    String? adminId,
  ) async {
    await FirebaseFirestore.instance
        .doc('admin/$adminId/consultation_schedule/$docId')
        .update(data);
    return;
  }

  // กำลังลบข้อมูลกำหนดการปรึกษาแพทย์
  deleteConsultationSchedule(
    String? docId,
    String? adminId,
  ) async {
    await FirebaseFirestore.instance
        .doc('admin/$adminId/consultation_schedule/$docId')
        .delete();
    return;
  }
}
