import 'package:flutter/material.dart';
import '../models/grievance_model.dart';
import '../services/firestore_service.dart';

class GrievanceProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Grievance> _grievances = [];
  bool _loading = false;

  List<Grievance> get grievances => _grievances;
  bool get isLoading => _loading;

  void listenToUserGrievances(String userId) {
    _loading = true;
    notifyListeners();
    _firestoreService.getUserGrievances(userId).listen((data) {
      _grievances = data;
      _loading = false;
      notifyListeners();
    });
  }

  void listenToAllGrievances() {
    _loading = true;
    notifyListeners();
    _firestoreService.getAllGrievances().listen((data) {
      _grievances = data;
      _loading = false;
      notifyListeners();
    });
  }

  Future<void> updateRating(String grievanceId, int rating) async {
    await _firestoreService.updateGrievance(grievanceId, {'rating': rating});
  }

  Future<void> addGrievance(Grievance grievance) async {
    await _firestoreService.addGrievance(grievance);
  }

  Future<int> getNextReferenceId() async {
    return _firestoreService.getNextGrievanceReferenceId();
  }

  Future<void> createAndAddGrievance({
    required String title,
    required String description,
    required String category,
    required String userId,
    String? imageUrl,
    String? remarks,
  }) async {
    final nextRefId = await _firestoreService.getNextGrievanceReferenceId();
    final grievance = Grievance(
      id: '',
      title: title,
      description: description,
      category: category,
      status: 'Pending',
      imageUrl: imageUrl,
      remarks: remarks,
      userId: userId,
      createdAt: DateTime.now(),
      referenceId: nextRefId,
    );
    await _firestoreService.addGrievance(grievance);
  }

  Future<void> updateGrievanceStatus(
    String id,
    String status, {
    String? remarks,
  }) async {
    await _firestoreService.updateGrievanceStatus(id, status, remarks: remarks);
  }
}
