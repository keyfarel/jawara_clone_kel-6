class KeluargaModel {
  final int id;
  final String kkNumber;
  final String ownershipStatus; 
  final String status;
  final String namaKepalaKeluarga; // Ini field dinamis (Bisa Nama / Bisa No KK)
  final String alamatRumah;
  final List<dynamic> citizens; 

  KeluargaModel({
    required this.id,
    required this.kkNumber,
    required this.ownershipStatus,
    required this.status,
    required this.namaKepalaKeluarga,
    required this.alamatRumah,
    required this.citizens,
  });

  factory KeluargaModel.fromJson(Map<String, dynamic> json) {
    String addr = '-';
    if (json['house'] != null) {
      addr = json['house']['address'] ?? '-';
    }

    // Ambil Nomor KK
    String noKK = json['kk_number'] ?? '-';

    // Ambil List Warga
    List<dynamic> listAnggota = json['citizens'] ?? [];

    // --- LOGIC PENENTUAN NAMA UTAMA ---
    // Default: Gunakan Nomor KK
    String displayName = noKK; 

    // Jika ada anggota keluarga, cari Kepala Keluarga
    if (listAnggota.isNotEmpty) {
      // Cari role 'kepala keluarga' atau 'head_of_family'
      var head = listAnggota.firstWhere(
        (c) {
          final role = (c['family_role'] ?? '').toString().toLowerCase();
          return role == 'kepala keluarga' || role == 'head_of_family';
        },
        // Jika tidak ada yang berstatus kepala keluarga, kembalikan null
        orElse: () => null, 
      );

      // Jika ketemu Kepala Keluarga, GANTI displayName jadi Namanya
      if (head != null) {
        displayName = head['name'] ?? noKK;
      } 
      // Opsi Tambahan: Jika tidak ada kepala keluarga tapi ada anggota lain, 
      // apakah tetap mau No KK atau nama anggota pertama?
      // Sesuai request Anda, jika belum ada kepala, kita biarkan No KK.
    }

    return KeluargaModel(
      id: json['id'],
      kkNumber: noKK,
      ownershipStatus: json['ownership_status'] ?? 'owner',
      status: json['status'] ?? 'active',
      namaKepalaKeluarga: displayName, // <--- Hasil Logic di atas
      alamatRumah: addr,
      citizens: listAnggota,
    );
  }
}