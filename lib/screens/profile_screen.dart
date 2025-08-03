import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFe8f5e9), Color(0xFFb2dfdb)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
          child: user == null
              ? const Center(child: Text('Not logged in'))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    children: [
                      // Academic Details Card
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.school, size: 32, color: Colors.green.shade700),
                                  const SizedBox(width: 16),
                                  Text(
                                    'Academic Details',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: Colors.green.shade700,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      final regController = TextEditingController(text: user.regNumber);
                                      final courseController = TextEditingController(text: user.course);
                                      final yearController = TextEditingController(text: user.currentYear);
                                      final sectionController = TextEditingController(text: user.section);
                                      final cgpaController = TextEditingController(text: user.cgpa);
                                      
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Edit Academic Details'),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller: regController,
                                                  decoration: const InputDecoration(labelText: 'Registration Number'),
                                                ),
                                                TextField(
                                                  controller: courseController,
                                                  decoration: const InputDecoration(labelText: 'Course'),
                                                ),
                                                TextField(
                                                  controller: yearController,
                                                  decoration: const InputDecoration(labelText: 'Current Year'),
                                                ),
                                                TextField(
                                                  controller: sectionController,
                                                  decoration: const InputDecoration(labelText: 'Section'),
                                                ),
                                                TextField(
                                                  controller: cgpaController,
                                                  decoration: const InputDecoration(labelText: 'CGPA'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('Cancel'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                try {
                                                  await authProvider.updateAcademicDetails(
                                                    user.id,
                                                    regNumber: regController.text,
                                                    course: courseController.text,
                                                    currentYear: yearController.text,
                                                    section: sectionController.text,
                                                    cgpa: cgpaController.text,
                                                  );
                                                  if (context.mounted) Navigator.pop(context);
                                                } catch (e) {
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text(e.toString())),
                                                    );
                                                  }
                                                }
                                              },
                                              child: const Text('Save'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const Divider(height: 32),
                              _buildInfoField('Registration Number', user.regNumber ?? 'Not set'),
                              _buildInfoField('Course', user.course ?? 'Not set'),
                              _buildInfoField('Current Year', user.currentYear ?? 'Not set'),
                              _buildInfoField('Section', user.section ?? 'Not set'),
                              _buildInfoField('CGPA', user.cgpa ?? 'Not set'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Personal Details Card
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person, size: 32, color: Colors.green.shade700),
                                  const SizedBox(width: 16),
                                  Text(
                                    'Personal Details',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: Colors.green.shade700,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      final nameController = TextEditingController(text: user.name);
                                      final phoneController = TextEditingController(text: user.phone);
                                      final addressController = TextEditingController(text: user.address);
                                      
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Edit Personal Details'),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller: nameController,
                                                  decoration: const InputDecoration(labelText: 'Name'),
                                                ),
                                                TextField(
                                                  controller: phoneController,
                                                  decoration: const InputDecoration(labelText: 'Phone'),
                                                ),
                                                TextField(
                                                  controller: addressController,
                                                  decoration: const InputDecoration(labelText: 'Address'),
                                                  maxLines: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('Cancel'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                try {
                                                  await authProvider.updatePersonalDetails(
                                                    user.id,
                                                    name: nameController.text,
                                                    phone: phoneController.text,
                                                    address: addressController.text,
                                                  );
                                                  if (context.mounted) Navigator.pop(context);
                                                } catch (e) {
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text(e.toString())),
                                                    );
                                                  }
                                                }
                                              },
                                              child: const Text('Save'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const Divider(height: 32),
                              _buildInfoField('Name', user.name),
                              _buildInfoField('Email', user.email),
                              _buildInfoField('Phone', user.phone ?? 'Not set'),
                              _buildInfoField('Address', user.address ?? 'Not set'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () async {
                            await authProvider.signOut();
                          },
                          child: const Text('Sign Out'),
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
} 