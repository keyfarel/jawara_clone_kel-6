import 'package:intl/intl.dart';

class MutasiModel {
  final int id;
  final DateTime tanggal;
  final String keluarga;
  final String jenisMutasiRaw; // Data mentah dari API (misal: move_out)
  final String alasan;

  // Field tambahan (jika nanti backend update, sementara kita defaultkan)
  final String alamatLama;
  final String alamatBaru;

  MutasiModel({
    required this.id,
    required this.tanggal,
    required this.keluarga,
    required this.jenisMutasiRaw,
    required this.alasan,
    this.alamatLama = '-',
    this.alamatBaru = '-',
  });

  factory MutasiModel.fromJson(Map<String, dynamic> json) {
    return MutasiModel(
      id: json['id'],
      tanggal: json['date'] != null 
          ? DateTime.parse(json['date']) 
          : DateTime.now(),
      keluarga: json['family_name'] ?? 'Tanpa Nama',
      jenisMutasiRaw: json['mutation_type'] ?? 'unknown',
      alasan: json['reason'] ?? '-',
      // Handle jika nanti backend mengirim alamat
      alamatLama: json['old_address'] ?? '-', 
      alamatBaru: json['new_address'] ?? '-',
    );
  }

  // Helper: Format Tanggal (30 Oktober 2023)
  String get formattedDate {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(tanggal);
  }

  // Helper: Format Jenis Mutasi yang enak dibaca
  String get jenisMutasiDisplay {
    switch (jenisMutasiRaw) {
      case 'move_out':
        return 'Keluar Perumahan';
      case 'move_in':
        return 'Warga Baru';
      case 'internal_move':
        return 'Pindah Blok';
      default:
        return jenisMutasiRaw.replaceAll('_', ' ').toUpperCase();
    }
  }
}