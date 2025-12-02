import 'package:intl/intl.dart'; // Import package intl

class ActivityModel {
  final int id;
  final String name;
  final DateTime activityDate; // Ubah tipe jadi DateTime
  final String description;
  final String status;
  final String category;

  ActivityModel({
    required this.id,
    required this.name,
    required this.activityDate,
    required this.description,
    required this.status,
    required this.category,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'],
      name: json['name'] ?? '',
      // Parsing string ISO 8601 ke DateTime
      // .toLocal() agar sesuai zona waktu HP pengguna (WIB/WITA/WIT)
      activityDate: json['activity_date'] != null
          ? DateTime.parse(json['activity_date']).toLocal()
          : DateTime.now(),
      description: json['description'] ?? '-', // Handle jika null
      status: json['status'] ?? 'pending',
      category: json['category'] ?? 'general',
    );
  }

  // Getter untuk tampilan UI yang rapi
  // Contoh Output: "28 Nov 2025, 18:42"
  String get formattedDate {
    return DateFormat('dd MMM yyyy, HH:mm').format(activityDate);
  }
}