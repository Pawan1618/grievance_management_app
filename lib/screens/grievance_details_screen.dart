import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/grievance_model.dart';
import '../models/user_model.dart';

class GrievanceDetailsScreen extends StatefulWidget {
  final Grievance grievance;
  final Function(String status, String remarks)? onStatusUpdate;

  const GrievanceDetailsScreen({
    super.key,
    required this.grievance,
    this.onStatusUpdate,
  });

  @override
  State<GrievanceDetailsScreen> createState() => _GrievanceDetailsScreenState();
}

class _GrievanceDetailsScreenState extends State<GrievanceDetailsScreen> {
  AppUser? studentDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudentDetails();
  }

  Future<void> _loadStudentDetails() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.grievance.userId)
          .get();
      
      if (userDoc.exists) {
        setState(() {
          studentDetails = AppUser.fromMap(
            userDoc.data() as Map<String, dynamic>,
            userDoc.id,
          );
        });
      }
    } catch (e) {
      print('Error loading student details: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildAcademicDetails() {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (studentDetails == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text('Student details not available'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Student Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00695c),
          ),
        ),
        const SizedBox(height: 12),
        _buildInfoRow('Name', studentDetails!.name),
        _buildInfoRow('Registration No.', studentDetails!.regNumber ?? 'N/A'),
        _buildInfoRow('Course', studentDetails!.course ?? 'N/A'),
        _buildInfoRow('Year', studentDetails!.currentYear ?? 'N/A'),
        _buildInfoRow('Section', studentDetails!.section ?? 'N/A'),
        if (studentDetails!.cgpa != null)
          _buildInfoRow('CGPA', studentDetails!.cgpa!),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00695c),
        title: const Text(
          'Grievance Details',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          if (widget.onStatusUpdate != null)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => widget.onStatusUpdate?.call(widget.grievance.status, widget.grievance.remarks ?? ''),
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe3f2fd), Color(0xFFb2dfdb)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.grievance.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00695c),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        _buildInfoChip(Icons.category, widget.grievance.category),
                        const SizedBox(width: 12),
                        _buildInfoChip(
                          Icons.pending_actions,
                          widget.grievance.status,
                          color: _getStatusColor(widget.grievance.status),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    _buildAcademicDetails(),
                    const Divider(height: 32),
                    _buildDetailRow('Description', widget.grievance.description),
                  if (widget.grievance.remarks != null && widget.grievance.remarks!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildDetailRow('Remarks', widget.grievance.remarks!),
                  ],
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Submitted on',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.grievance.createdAt.day.toString().padLeft(2, '0')}-${widget.grievance.createdAt.month.toString().padLeft(2, '0')}-${widget.grievance.createdAt.year}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${widget.grievance.createdAt.hour.toString().padLeft(2, '0')}:${widget.grievance.createdAt.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      if (widget.grievance.rating != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Rating',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: List.generate(
                                5,
                                (index) => Icon(
                                  index < widget.grievance.rating! ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Resolved':
        return Colors.green;
      case 'In Progress':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildInfoChip(IconData icon, String label, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (color ?? Colors.grey).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: (color ?? Colors.grey).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color ?? Colors.grey),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color ?? Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
