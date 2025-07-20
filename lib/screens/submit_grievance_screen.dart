import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/auth_provider.dart';
import '../providers/grievance_provider.dart';
import '../models/grievance_model.dart';
import 'dart:io';

class SubmitGrievanceScreen extends StatefulWidget {
  const SubmitGrievanceScreen({super.key});

  @override
  State<SubmitGrievanceScreen> createState() => _SubmitGrievanceScreenState();
}

class _SubmitGrievanceScreenState extends State<SubmitGrievanceScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _category = 'Academic'; // instead of 'General'
  String? _subCategory;
  File? _image;
  final List<String> _categories = [
    'Academic',
    'Hostel',
    'Administrative',
    'Disciplinary',
    'Health & Safety',
    'IT & Infrastructure',
    'Equality & Harassment',
    'Placement & Career',
    'Campus Facilities',
    'Miscellaneous',
  ];

  final Map<String, List<String>> _subCategories = {
    'Academic': [
      'Curriculum-related issues',
      'Exam & Evaluation',
      'Attendance discrepancies',
      'Class rescheduling',
      'Faculty behavior',
      'Assignment or internal marks',
      'Lab/Practical issues',
      'Timetable conflicts',
    ],
    'Hostel': [
      'Room allocation',
      'Cleanliness & sanitation',
      'Mess food quality',
      'Water supply',
      'Electricity issues',
      'Wi-Fi/Internet problems',
      'Wardens/Staff behavior',
      'Maintenance requests',
    ],
    'Administrative': [
      'Fees & Dues',
      'Scholarships & Stipends',
      'ID card or documents delay',
      'Certificate/Transcript issues',
      'Registration & Enrollment',
      'Transport services',
      'Mismanagement by office staff',
    ],
    'Disciplinary': [
      'Ragging or bullying',
      'Code of conduct violation',
      'Harassment complaint',
      'Unauthorized activities',
      'Substance abuse',
    ],
    'Health & Safety': [
      'Medical emergency response',
      'Health center services',
      'Mental health support',
      'Safety hazards',
      'Covid-related issues',
    ],
    'IT & Infrastructure': [
      'Smart classroom issues',
      'Projector/AV malfunction',
      'Campus Wi-Fi problems',
      'LMS/Portal access issues',
      'App/Website bugs',
      'Biometric attendance issues',
    ],
    'Equality & Harassment': [
      'Gender discrimination',
      'Caste-based issues',
      'Disability support',
      'Sexual harassment',
      'Bias in evaluation',
    ],
    'Placement & Career': [
      'Internship help',
      'Placement procedure issues',
      'Company selection bias',
      'Resume building support',
      'Communication gap with placement cell',
    ],
    'Campus Facilities': [
      'Library services',
      'Sports facilities',
      'Cafeteria & canteen',
      'Drinking water',
      'Washroom hygiene',
      'Parking issues',
    ],
    'Miscellaneous': [
      'Lost & Found',
      'Suggestions/Feedback',
      'Complaint against unknown person',
      'Others (with optional description)',
    ],
  };

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final grievanceProvider = Provider.of<GrievanceProvider>(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFe0f2f1), Color(0xFFb2dfdb)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Submit Grievance',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      onChanged: (v) => _title = v,
                      validator: (v) => v == null || v.isEmpty ? 'Enter a title' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _category,
                      items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (v) {
                        setState(() {
                          _category = v ?? _categories.first;
                          final subList = _subCategories[_category];
                          _subCategory = (subList != null && subList.isNotEmpty) ? subList.first : null;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                    if (_subCategories[_category] != null && _subCategories[_category]!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: DropdownButtonFormField<String>(
                          value: _subCategory ?? _subCategories[_category]!.first,
                          items: _subCategories[_category]!
                              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                              .toList(),
                          onChanged: (v) => setState(() => _subCategory = v),
                          validator: (v) => v == null || v.isEmpty ? 'Select a subcategory' : null,
                          decoration: InputDecoration(
                            labelText: 'Subcategory',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text('Pick Image (optional)'),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: Colors.green.shade700),
                        foregroundColor: Colors.green.shade700,
                      ),
                    ),
                    if (_image != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_image!, height: 100),
                        ),
                      ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      maxLines: 3,
                      onChanged: (v) => _description = v,
                      validator: (v) => v == null || v.isEmpty ? 'Enter a description' : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate() && user != null) {
                          final grievance = Grievance(
                            id: '',
                            title: _title,
                            description: _description,
                            category: _category + (_subCategory != null ? ' - $_subCategory' : ''),
                            status: 'Pending',
                            imageUrl: null, // Image upload to be implemented
                            remarks: null,
                            userId: user.id,
                            createdAt: DateTime.now(),
                          );
                          await grievanceProvider.addGrievance(grievance);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Grievance submitted!')));
                            _formKey.currentState!.reset();
                            setState(() => _image = null);
                          }
                        }
                      },
                      child: const Text('Submit'),
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
} 