// lib/data/models/keluarga_model.dart

class KeluargaModel {
  final int id;
  final String kkNumber;
  final String ownershipStatus; 
  final String status;
  final String namaKepalaKeluarga; 
  final String alamatRumah;
  
  // TAMBAHAN: Menyimpan list anggota keluarga mentah dari API
  final List<dynamic> citizens; 

  KeluargaModel({
    required this.id,
    required this.kkNumber,
    required this.ownershipStatus,
    required this.status,
    required this.namaKepalaKeluarga,
    required this.alamatRumah,
    required this.citizens, // Tambahkan di constructor
  });

  factory KeluargaModel.fromJson(Map<String, dynamic> json) {
    String addr = '-';
    if (json['house'] != null) {
      addr = json['house']['address'] ?? '-';
    }

    // Ambil list citizens dari JSON
    List<dynamic> listAnggota = json['citizens'] ?? [];

    // Cari Nama Kepala Keluarga
    String kkName = 'Belum Ada KK';
    if (listAnggota.isNotEmpty) {
      final head = listAnggota.firstWhere(
        (c) {
          final role = (c['family_role'] ?? '').toString().toLowerCase();
          return role == 'kepala keluarga' || role == 'head_of_family' || role == 'husband';
        },
        orElse: () => listAnggota.first,
      );
      kkName = head['name'] ?? '-';
    }

    return KeluargaModel(
      id: json['id'],
      kkNumber: json['kk_number'] ?? '-',
      ownershipStatus: json['ownership_status'] ?? 'owner',
      status: json['status'] ?? 'active',
      namaKepalaKeluarga: kkName,
      alamatRumah: addr,
      citizens: listAnggota, // Simpan listnya di sini
    );
  }
}