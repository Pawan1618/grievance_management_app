import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/grievance_provider.dart';
import '../models/grievance_model.dart';
import '../providers/auth_provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String? _statusFilter;
  String? _categoryFilter;
  final List<String> _statuses = ['Pending', 'In Progress', 'Resolved'];
  final List<String> _categories = ['Academic',
    'Hostel',
    'Administrative',
    'Disciplinary',
    'Health & Safety',
    'IT & Infrastructure',
    'Equality & Harassment',
    'Placement & Career',
    'Campus Facilities',
    'Miscellaneous',];

  Color _statusColor(String status) {
    switch (status) {
      case 'Resolved':
        return Colors.green.shade600;
      case 'In Progress':
        return Colors.orange.shade700;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final grievanceProvider = Provider.of<GrievanceProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    grievanceProvider.listenToAllGrievances();
    final grievances = grievanceProvider.grievances.where((g) {
      final statusMatch = _statusFilter == null || g.status == _statusFilter;
      final categoryMatch = _categoryFilter == null || g.category == _categoryFilter;
      return statusMatch && categoryMatch;
    }).toList();
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFe3f2fd), Color(0xFFb2dfdb)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color(0xFF00695c),
          title: const Text('Admin Dashboard', style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Sign Out',
              color: Colors.white,
              onPressed: () async {
                await authProvider.signOut();
              },
            ),
          ],
        ),
        body: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _statusFilter,
                          hint: const Text('Status'),
                          items: [null, ..._statuses].map((s) => DropdownMenuItem(value: s, child: Text(s ?? 'All'))).toList(),
                          onChanged: (v) => setState(() => _statusFilter = v),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _categoryFilter,
                          hint: const Text('Category'),
                          items: [null, ..._categories].map((c) => DropdownMenuItem(value: c, child: Text(c ?? 'All'))).toList(),
                          onChanged: (v) => setState(() => _categoryFilter = v),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: grievances.isEmpty
                        ? const Center(child: Text('No grievances found.'))
                        : ListView.separated(
                            padding: const EdgeInsets.all(8),
                            itemCount: grievances.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, i) {
                              final g = grievances[i];
                              return Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                  title: Text(g.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(g.category, style: const TextStyle(color: Colors.black54)),
                                      const SizedBox(height: 4),
                                      Text(g.description,style: const TextStyle(color: Colors.black)),
                                      const SizedBox(height: 8),
                                      Text(g.remarks ?? '', style: const TextStyle(color: Colors.black54)),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Chip(
                                            label: Text(g.status),
                                            backgroundColor: _statusColor(
                                              g.status,
                                            ).withOpacity(0.15),
                                            labelStyle: TextStyle(
                                              color: _statusColor(g.status),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '${g.createdAt.day.toString().padLeft(2, '0')}-${g.createdAt.month.toString().padLeft(2, '0')}-${g.createdAt.year} ${g.createdAt.hour.toString().padLeft(2, '0')}:${g.createdAt.minute.toString().padLeft(2, '0')}',
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _showStatusDialog(context, g, grievanceProvider),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showStatusDialog(BuildContext context, Grievance g, GrievanceProvider provider) {
    String status = g.status;
    String remarks = g.remarks ?? '';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Update Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: status,
              items: _statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => status = v ?? g.status,
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            TextFormField(
              initialValue: remarks,
              decoration: const InputDecoration(labelText: 'Remarks'),
              onChanged: (v) => remarks = v,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await provider.updateGrievanceStatus(g.id, status, remarks: remarks);
              if (context.mounted) Navigator.pop(ctx);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
} 