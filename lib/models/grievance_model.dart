import 'package:cloud_firestore/cloud_firestore.dart';

class Grievance {
  final String id;
  final String title;
  final String description;
  final String category;
  final String status; // Pending, In Progress, Resolved
  final String? imageUrl;
  final String? remarks;
  final String userId;
  final DateTime createdAt;
  final int? rating;
  final int referenceId;

  Grievance({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    this.imageUrl,
    this.remarks,
    required this.userId,
    required this.createdAt,
    this.rating,
    required this.referenceId,
  });

  factory Grievance.fromMap(Map<String, dynamic> map, String id) {
    return Grievance(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      status: map['status'] ?? 'Pending',
      imageUrl: map['imageUrl'],
      remarks: map['remarks'],
      userId: map['userId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      rating: map['rating'],
      referenceId: (map['referenceId'] is int)
          ? map['referenceId'] as int
          : int.tryParse(map['referenceId']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'imageUrl': imageUrl,
      'remarks': remarks,
      'userId': userId,
      'createdAt': createdAt,
      'rating': rating,
      'referenceId': referenceId,
    };
  }
}
