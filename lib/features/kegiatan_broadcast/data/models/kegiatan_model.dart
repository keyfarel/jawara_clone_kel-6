import 'package:intl/intl.dart';

class KegiatanModel {
  final int id;
  final String name;
  final DateTime activityDate;
  final String location;
  final String status;
  final String category;
  final String personInCharge;
  final String? description;

  KegiatanModel({
    required this.id,
    required this.name,
    required this.activityDate,
    required this.location,
    required this.status,
    required this.category,
    required this.personInCharge,
    this.description,
  });

  factory KegiatanModel.fromJson(Map<String, dynamic> json) {
    return KegiatanModel(
      id: json['id'],
      name: json['name'] ?? 'Tanpa Nama',
      activityDate: json['activity_date'] != null
          ? DateTime.parse(json['activity_date']).toLocal()
          : DateTime.now(),
      location: json['location'] ?? '-',
      status: json['status'] ?? 'upcoming',
      category: json['category'] ?? 'general',
      personInCharge: json['person_in_charge'] ?? '-',
      description: json['description'],
    );
  }

  // Format Tanggal: 10 Nov 2023
  String get formattedDate {
    return DateFormat('dd MMM yyyy', 'id_ID').format(activityDate);
  }

  // Format Status untuk UI
  String get statusDisplay {
    switch (status) {
      case 'upcoming': return 'Akan Datang';
      case 'ongoing': return 'Berlangsung';
      case 'completed': return 'Selesai';
      case 'cancelled': return 'Dibatalkan';
      default: return status;
    }
  }
}