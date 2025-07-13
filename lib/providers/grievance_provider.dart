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

  Future<void> addGrievance(Grievance grievance) async {
    await _firestoreService.addGrievance(grievance);
  }

  Future<void> updateGrievanceStatus(String id, String status, {String? remarks}) async {
    await _firestoreService.updateGrievanceStatus(id, status, remarks: remarks);
  }
} 