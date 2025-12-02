import 'package:intl/intl.dart';

class MutasiModel {
  final int id;
  final String keluarga; // Nama Keluarga
  final String jenisMutasi; // Pindah Rumah / Keluar
  final String alamatLama;
  final String alamatBaru;
  final String alasan;
  final String status;
  final DateTime tanggal;

  MutasiModel({
    required this.id,
    required this.keluarga,
    required this.jenisMutasi,
    required this.alamatLama,
    required this.alamatBaru,
    required this.alasan,
    required this.status,
    required this.tanggal,
  });

  factory MutasiModel.fromJson(Map<String, dynamic> json) {
    return MutasiModel(
      id: json['id'],
      keluarga: json['family_name'] ?? 'Tanpa Nama',
      jenisMutasi: json['mutation_type'] ?? '-',
      alamatLama: json['old_address'] ?? '-',
      alamatBaru: json['new_address'] ?? '-',
      alasan: json['reason'] ?? '-',
      status: json['status'] ?? 'pending',
      tanggal: json['mutation_date'] != null
          ? DateTime.parse(json['mutation_date'])
          : DateTime.now(),
    );
  }

  // Helper untuk format tanggal (contoh: 30 September 2025)
  String get formattedDate {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(tanggal);
  }
}