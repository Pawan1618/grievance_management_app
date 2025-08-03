class AppUser {
  final String id;
  final String name;
  final String email;
  final String role; // 'admin' or 'user'
  final String? regNumber;
  final String? course;
  final String? currentYear;
  final String? section;
  final String? cgpa;
  final String? phone;
  final String? address;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.regNumber,
    this.course,
    this.currentYear,
    this.section,
    this.cgpa,
    this.phone,
    this.address,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    return AppUser(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'user',
      regNumber: map['regNumber'],
      course: map['course'],
      currentYear: map['currentYear'],
      section: map['section'],
      cgpa: map['cgpa'],
      phone: map['phone'],
      address: map['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'regNumber': regNumber,
      'course': course,
      'currentYear': currentYear,
      'section': section,
      'cgpa': cgpa,
      'phone': phone,
      'address': address,
    };
  }
} 