class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role; // resident, admin, etc
  final String registrationStatus; // verified, pending
  final String? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.registrationStatus,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'resident',
      registrationStatus: json['registration_status'] ?? 'pending',
      createdAt: json['created_at'],
    );
  }

  // Untuk keperluan Edit/Update
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
    };
  }
}