import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/grievance_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<int> getNextGrievanceReferenceId() async {
    final DocumentReference counterRef = _db.collection('counters').doc('grievance_reference');
    return _db.runTransaction<int>((transaction) async {
      final snapshot = await transaction.get(counterRef);
      int last = 1000;
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final value = data['last'];
        if (value is int) {
          last = value;
        } else if (value is String) {
          last = int.tryParse(value) ?? 1000;
        }
      }
      final next = last + 1; // first will be 1001
      transaction.set(counterRef, {'last': next}, SetOptions(merge: true));
      return next;
    });
  }

  Future<void> addGrievance(Grievance grievance) async {
    await _db.collection('grievances').add(grievance.toMap());
  }

  Stream<List<Grievance>> getUserGrievances(String userId) {
    return _db
        .collection('grievances')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Grievance.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<Grievance>> getAllGrievances() {
    return _db
        .collection('grievances')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Grievance.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> updateGrievance(
    String grievanceId,
    Map<String, dynamic> data,
  ) async {
    await _db.collection('grievances').doc(grievanceId).update(data);
  }

  Future<void> updateGrievanceStatus(
    String id,
    String status, {
    String? remarks,
  }) async {
    await _db.collection('grievances').doc(id).update({
      'status': status,
      if (remarks != null) 'remarks': remarks,
    });
  }
}
