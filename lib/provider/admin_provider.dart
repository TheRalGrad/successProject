import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:telekonsul/models/queue/queue.dart';
import 'package:telekonsul/models/admin/admin.dart';
import 'package:telekonsul/models/consultation_schedule/work_schedule.dart';

class DoctorProvider with ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isLoadingSpecialist = true;
  bool get isLoadingSpecialist => _isLoadingSpecialist;
  set setLoadingSpecialist(bool value) => _isLoadingSpecialist = value;

  Doctor? _admin;
  Doctor? get admin => _admin;
  set setDoctor(Doctor? admin) {
    _admin = admin;
    notifyListeners();
  }

  List<DataDoctor> _listDoctor = [];
  List<DataDoctor> get listDoctor => _listDoctor;

  List<DataDoctor> _listSpecialistDoctor = [];
  List<DataDoctor> get listSpecialistDoctor => _listSpecialistDoctor;

  // รับข้อมูล Admin ที่มีอยู่สำหรับวันนี้
  // ข้อมูล Admin นี้จะแสดงที่หน้าหลักของผู้ใช้
  getAllDoctor(String? userUid) async {
    _isLoading = true;
    _listDoctor.clear();

    // รับข้อมูลจาก admin collection
    final dataDoctor =
        await FirebaseFirestore.instance.collection('admin').get();

    // ถ้ามันว่างเปล่า, มันจะถูก returned โดยไม่มีค่า
    if (dataDoctor.docs.isEmpty) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    // หากไม่มี, ก็จะกำหนดให้รายการ Admin เพิ่มข้อมูลทั้งหมด
    // AdminData ต้องการ admin, ตารางงาน และ isBooked (เพื่อตรวจสอบว่าผู้ใช้จองผู้ใช้นี้แล้วหรือไม่)
    _listDoctor.addAll(
      dataDoctor.docs.map(
        (e) => DataDoctor()
          ..admin = Doctor.fromJson(e.data())
          ..consultationSchedule = []
          ..isBooked = false,
      ),
    );

    // หลังจากกำหนดข้อมูลแล้ว, ต่อไป เราต้องได้รับ work schedule จาก Admin ทุกกลุ่มย่อย
    // ใช้ Future.forEach เพื่อทำให้ loop async
    await Future.forEach<DataDoctor>(_listDoctor, (element) async {
      // รับข้อมูล work schedule ,ด้วย Admin uid จาก element
      final dataJadwal = await FirebaseFirestore.instance
          .doc('admin/${element.admin.uid}')
          .collection('consultation_schedule')
          .get();

      // ถ้ามันว่าง, ผู้ใช้คนไหนก็จอง Admin คนนี้ไม่ได้ และแน่นอนว่ายังไม่มีใครจอง
      if (dataJadwal.docs.isEmpty) {
        element.consultationSchedule.addAll([]);
        element.isBooked = false;
        return;
      }

      // ถ้าไม่, เราจะอัปเดต work schedule element
      element.consultationSchedule.addAll(
          dataJadwal.docs.map((e) => ConsultationSchedule.fromJson(e.data())));

      // และการตรวจสอบว่า user จอง Admin คนนี้แล้วหรือไม่, ด้วยวิธีการที่เราทำไว้แล้วใน class นี้เช่นกัน
      element.isBooked = await checkIfBooked(element.admin.uid, userUid);
    });

    // Get the admin where, กำหนดการทำงานคือวันนี้ โดยอิงจากค่า day intValue
    // วันจันทร์คือ (1) .... วันอาทิตย์ (7)
    _listDoctor = _listDoctor
        .where((element) => element.consultationSchedule.any((element) =>
            element.daySchedule!.intValue == DateTime.now().weekday))
        .toList();

    // เราแสดงเพียง 7 data ในหน้าหลักของผู้ใช้
    // ดังนั้นมันจะโหลดเร็วขึ้น และ UI ก็จะเรียบร้อย
    // สามารถดูเพิ่มเติมได้ในรายการ Admin Specialist
    if (_listDoctor.length > 7) {
      _listDoctor.removeRange(8, _listDoctor.length);
    }
    _isLoading = false;
    notifyListeners();
    return;
  }

  // กระบวนการเหมือนกันกับ getAllAdmin ต่างกันตรงที่เราได้ Admin เฉพาะทางเท่านั้น ไม่ใช่ Admin ทุกคน
  // ใช้ .where('specialist', isEqualTo: specialist)
  getDoctorSpecialist(String specialist, String? userUid) async {
    _isLoadingSpecialist = true;
    _listSpecialistDoctor.clear();

    final dataDoctor = await FirebaseFirestore.instance
        .collection('admin')
        .where('specialist', isEqualTo: specialist)
        .get();

    if (dataDoctor.docs.isEmpty) {
      _isLoadingSpecialist = false;
      notifyListeners();
      return;
    }

    _listSpecialistDoctor.addAll(
      dataDoctor.docs.map(
        (e) => DataDoctor()
          ..admin = Doctor.fromJson(e.data())
          ..consultationSchedule = []
          ..isBooked = false,
      ),
    );

    await Future.forEach<DataDoctor>(_listSpecialistDoctor, (element) async {
      final dataJadwal = await FirebaseFirestore.instance
          .doc('admin/${element.admin.uid}')
          .collection('consultation_schedule')
          .get();

      if (dataJadwal.docs.isEmpty) {
        element.consultationSchedule.addAll([]);
        element.isBooked = false;
        return;
      }

      element.consultationSchedule.addAll(
          dataJadwal.docs.map((e) => ConsultationSchedule.fromJson(e.data())));

      element.isBooked = await checkIfBooked(element.admin.uid, userUid);
    });
    _listSpecialistDoctor = _listSpecialistDoctor
        .where((element) => element.consultationSchedule.any((element) =>
            element.daySchedule!.intValue == DateTime.now().weekday))
        .toList();
    _isLoadingSpecialist = false;
    notifyListeners();
    return;
  }

  // อัปเดตข้อมูล Admin หาก Admin เปลี่ยนโปรไฟล์
  updateDoctor(String uid, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.doc('admin/$uid').update(data);
    notifyListeners();
    return;
  }

  // เช็คงานที่แอดมินปล่อย
  checkIfBooked(String? adminId, String? userUid) async {
    bool isBooked = false;

    final dataQueueDoctor = await FirebaseFirestore.instance
        .doc('admin/$adminId')
        .collection('queue')
        .where('is_done', isEqualTo: false)
        .get();

    if (dataQueueDoctor.docs.isEmpty) {
      return isBooked;
    }

    List<Queue> dataQueue = [];
    dataQueue.addAll(dataQueueDoctor.docs.map((e) => Queue.fromJson(e.data())));

    // พรุ่งนี้
    DateTime before = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);

    // เมื่อวาน
    DateTime after = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day - 1, 24, 0);

    // เช็คคิววันนี้
    dataQueue = dataQueue
        .where(
          (element) =>
              element.createdAt.isBefore(before) &&
              element.createdAt.isAfter(after),
        )
        .toList();

    // ตรวจว่างานนั้นสร้างโดยผู้ใช้หรือไม่ คือ คนนอกจองงานกับแอดมินไว้แล้ว
    isBooked = dataQueue
        .any((element) => element.transactionData!.createdBy!.uid == userUid);

    return isBooked;
  }
}
