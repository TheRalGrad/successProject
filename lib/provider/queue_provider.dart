import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:telekonsul/models/queue/queue.dart';

class QueueProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Queue> _listQueue = [];
  List<Queue> get listQueue => _listQueue;

  List<Queue> _listAllQueue = [];
  List<Queue> get listAllQueue => _listAllQueue;

  // พรุ่งนี้
  DateTime before = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);

  // เมื่อวาน
  DateTime after = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 1, 24, 0);

  // รับข้อมูลคิวจาก Admin subCollection เพื่อแสดงในหน้าหลักของ Admin จำกัดที่ 7
  // และเรารับเฉพาะข้อมูลคิวที่ยังไม่ได้ดำเนินการ และเรียงลำดับจากหมายเลขคิว
  get7Queue(String? adminId) async {
    _isLoading = true;
    _listQueue.clear();

    try {
      await FirebaseFirestore.instance
          .doc('admin/$adminId')
          .collection('queue')
          .orderBy('queue_number', descending: false)
          .limit(7)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        _listQueue.addAll(value.docs.map((e) => Queue.fromJson(e.data())));

        _listQueue = _listQueue
            .where(
              (element) =>
                  element.createdAt.isBefore(before) &&
                  element.createdAt.isAfter(after),
            )
            .toList();

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

  // ตรงนี้จะเหมือนกับ method ด้านบน แต่คราวนี้เราได้ข้อมูลทั้งหมด
  getAllQueue(String? adminId) async {
    _isLoading = true;
    _listAllQueue.clear();

    try {
      await FirebaseFirestore.instance
          .doc('admin/$adminId')
          .collection('queue')
          .orderBy('queue_number', descending: false)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        _listAllQueue.addAll(value.docs.map((e) => Queue.fromJson(e.data())));

        _listAllQueue = _listAllQueue
            .where(
              (element) =>
                  element.createdAt.isBefore(before) &&
                  element.createdAt.isAfter(after),
            )
            .toList();

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

  // การเพิ่มข้อมูลคิวไปยัง Admin subCollection
  addQueue(String? adminId, Map<String, dynamic> data) async {
    _isLoading = true;

    try {
      await FirebaseFirestore.instance
          .doc('admin/$adminId/queue/${data['doc_id']}')
          .set(data);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return;
    }
  }

  // กำลังอัปเดตหมายเลขคิว
  updateQueueNumber({
    String? adminId,
    String? queueId,
    int? number,
  }) async {
    _isLoading = true;

    try {
      await FirebaseFirestore.instance
          .doc('admin/$adminId/queue/$queueId')
          .update({
        'queue_number': number,
      });
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return;
    }
  }
}
