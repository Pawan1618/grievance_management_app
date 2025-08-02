import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/grievance_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
