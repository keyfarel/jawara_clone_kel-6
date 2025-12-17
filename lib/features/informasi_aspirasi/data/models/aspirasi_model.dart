class AspirasiResponse {
  final bool success;
  final String message;
  final List<AspirasiModel> data;

  AspirasiResponse({required this.success, required this.message, required this.data});

  factory AspirasiResponse.fromJson(Map<String, dynamic> json) {
    return AspirasiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List).map((i) => AspirasiModel.fromJson(i)).toList(),
    );
  }
}

class AspirasiModel {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String status;
  final DateTime createdAt;
  final AspirasiUser user;

  AspirasiModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.user,
  });

  factory AspirasiModel.fromJson(Map<String, dynamic> json) {
    return AspirasiModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      user: AspirasiUser.fromJson(json['user']),
    );
  }
}

class AspirasiUser {
  final int id;
  final String email;
  final String role;

  AspirasiUser({required this.id, required this.email, required this.role});

  factory AspirasiUser.fromJson(Map<String, dynamic> json) {
    return AspirasiUser(
      id: json['id'],
      email: json['email'] ?? '',
      role: json['role'] ?? '',
    );
  }
}