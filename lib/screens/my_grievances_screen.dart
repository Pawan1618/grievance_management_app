import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/grievance_provider.dart';

class MyGrievancesScreen extends StatefulWidget {
  const MyGrievancesScreen({super.key});

  @override
  State<MyGrievancesScreen> createState() => _MyGrievancesScreenState();
}

class _MyGrievancesScreenState extends State<MyGrievancesScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      Provider.of<GrievanceProvider>(
        context,
        listen: false,
      ).listenToUserGrievances(user.id);
    }
  }

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
    final grievances = grievanceProvider.grievances;
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          grievanceProvider.listenToAllGrievances();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Loading all grievances...'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        child: const Icon(Icons.list_alt),
        tooltip: 'View All Grievances',
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe3f2fd), Color(0xFFb2ebf2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: grievances.isEmpty
            ? const Center(child: Text('No grievances submitted.'))
            : ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: grievances.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final g = grievances[i];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              g.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Ref ID: ${g.referenceId}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            g.category,
                            style: const TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 8),
                          Row(
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
                            ],
                          ),
                          if (g.remarks != null && g.remarks!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Remark: ${g.remarks!}',
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ],
                          if (g.status == 'Resolved') ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'Rate: ',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                ...List.generate(
                                  5,
                                  (index) => GestureDetector(
                                    onTap: () {
                                      final grievanceProvider =
                                          Provider.of<GrievanceProvider>(
                                        context,
                                        listen: false,
                                      );
                                      grievanceProvider.updateRating(
                                        g.id,
                                        index + 1,
                                      );
                                    },
                                    child: Icon(
                                      g.rating != null && g.rating! > index
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                      trailing: Icon(
                        g.status == 'Resolved'
                            ? Icons.check_circle
                            : g.status == 'In Progress'
                                ? Icons.timelapse
                                : Icons.pending,
                        color: _statusColor(g.status),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
