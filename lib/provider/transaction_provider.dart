import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:telekonsul/models/transaction/transaction_model.dart';
import 'package:telekonsul/provider/patient_provider.dart';

class TransactionProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<TransactionModel> _listTransaction = [];
  List<TransactionModel> get listTransaction => _listTransaction;

  TransactionModel? _transaction;
  TransactionModel? get transaksi => _transaction;

  PatientProvider? _patientProvider;
  PatientProvider? get patientProvider => _patientProvider;

  // สำหรับการอัปเดตค่าของ UserProvider เราใช้บน main.dart สำหรับ ChangeNotifierProxyProvider
  set updatePatientProvider(PatientProvider value) {
    _patientProvider = value;
    notifyListeners();
  }

  // นำข้อมูลการทำงานทั้งหมดไปไว้ใน subCollection ของ Admin หรือ User
  // เราต้องการ uid ของผู้ใช้เพื่อเข้าสู่ subCollection
  getAllTransaction(bool isDokter, String? uid) async {
    String role = isDokter ? 'admin' : 'users';
    _isLoading = true;
    _listTransaction.clear();

    try {
      await FirebaseFirestore.instance
          .doc('$role/$uid')
          .collection('transaction')
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        _listTransaction
            .addAll(value.docs.map((e) => TransactionModel.fromJson(e.data())));
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

  // การเพิ่มข้อมูล ระบบยืนยันงาน และข้อมูล User ไปยังกลุ่มย่อยของ Admin
  Future<TransactionModel?> addTransaction({
    String? adminId,
    required Map<String, dynamic> dataTransaction,
    required Map<String, dynamic> dataPatient,
    String? userUid,
  }) async {
    _isLoading = true;
    _transaction = null;

    // การเพิ่มข้อมูล ระบบส่งงาน ใน SubCollection ของ Admin เราจำเป็นต้องมี ID Admin เพื่อเข้าถึง SubCollection ของ ระบบส่งงาน
    await FirebaseFirestore.instance
        .doc('admin/$adminId')
        .collection('transaction')
        .add(dataTransaction)
        .then((value) async {
      // จากนั้นเรา อัปเดตเอกสารด้วย document id
      await value.update({
        'doc_id': value.id,
      });

      // รับ document data
      final data = await value.get();

      // กำหนดค่าข้อมูลเป็น ระบบส่งงาน (_transaction)
      _transaction = TransactionModel.fromJson(data.data()!);

      // เพิ่ม admin_id ให้กับ dataTransaction เนื่องจากเราต้องการให้แน่ใจว่าทุกงานที่มีข้อมูลเดียวกันมี documentID เดียวกัน
      // ดังนั้นมันจะง่ายกว่าหากมีการเปลี่ยนแปลงในเอกสารเหล่านั้น เราสามารถเปลี่ยนเอกสารอื่นได้ด้วยเพราะมี documentID เดียวกัน
      dataTransaction['doc_id'] = value.id;
    });

    // นี่คือการตั้งค่าข้อมูลเป็น User subCollection เราต้องการเพื่อให้ผู้ใช้สามารถรับประวัติการทำงานในภายหลัง
    await FirebaseFirestore.instance
        .doc('users/$userUid/transaction/${dataTransaction['doc_id']}')
        .set(dataTransaction);

    // UserProvider ได้รับการส่งผ่านวิธีการ update method (ชุด)
    // ดังนั้นเราจึงสามารถใช้มัน เพื่อเพิ่ม User ใน Admin subCollection
    await _patientProvider!.addPatient(adminId, dataPatient);

    _isLoading = true;
    notifyListeners();

    return _transaction;
  }

  // นี่คือเหตุผลที่เราต้องการให้ระบบส่งงานทั้งหมดมี documentID เดียวกัน
  // มันทำให้เราเปลี่ยนข้อมูลได้หมด เพราะเรารู้ว่า documentID มันเหมือนกันอยู่แล้ว

  // รูปภาพถูกอัปโหลดไปยัง Firebase Storage แล้ว ดังนั้นสิ่งที่เราต้องมีคือ imgUrl
  // และเราเปลี่ยนสถานะเป็น รอการยืนยัน ผู้ใช้จะรอ Admin ยืนยันการทำงานเสร็จสิ้น

  confirmPayment(
      String? docId, String? adminId, String imgUrl, String? userUid) async {
    _isLoading = true;

    await FirebaseFirestore.instance
        .doc('admin/$userUid/transaction/$docId')
        .update({
      'payment_proof': imgUrl,
      'status': "Waiting for Confirmation",
    });

    await FirebaseFirestore.instance
        .doc('admin/$adminId/transaction/$docId')
        .update({
      'payment_proof': imgUrl,
      'status': "Waiting for Confirmation",
    });

    await FirebaseFirestore.instance.doc('admin/$adminId/queue/$docId').update({
      'payment_proof': imgUrl,
      'status': "Waiting for Confirmation",
    });

    _isLoading = false;
    notifyListeners();
    return;
  }

  // สำหรับอัพเดทสถานะระบบส่งงาน ทั้งสำเร็จ หรือล้มเหลว
  updateStatus(
      String? docId, String? userId, String? status, String? adminId) async {
    _isLoading = true;

    await FirebaseFirestore.instance
        .doc('admin/$userId/transaction/$docId')
        .update({
      'status': status,
    });

    await FirebaseFirestore.instance
        .doc('admin/$adminId/transaction/$docId')
        .update({
      'status': status,
    });

    await FirebaseFirestore.instance.doc('admin/$adminId/queue/$docId').update({
      'status': status,
    });

    _isLoading = false;
    notifyListeners();
    return;
  }
}
