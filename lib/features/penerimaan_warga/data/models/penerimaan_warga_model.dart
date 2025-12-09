class PenerimaanWargaModel {
  final int id;
  final int? userId;
  final String nama;
  final String nik;
  final String jenisKelamin;
  final String peranKeluarga;
  final String noHp;
  final String? email;
  final String? statusRegistrasi;
  final String? fotoIdentitas;

  PenerimaanWargaModel({
    required this.id,
    this.userId,
    required this.nama,
    required this.nik,
    required this.jenisKelamin,
    required this.peranKeluarga,
    required this.noHp,
    this.email,
    this.statusRegistrasi,
    this.fotoIdentitas,
  });

  factory PenerimaanWargaModel.fromJson(Map<String, dynamic> json) {
    return PenerimaanWargaModel(
      id: json['id'],
      userId: json['user_id'],
      nama: json['nama'] ?? 'Tanpa Nama',
      nik: json['nik'] ?? '-',
      jenisKelamin: json['jenis_kelamin'] ?? '-',
      peranKeluarga: json['peran_keluarga'] ?? '-',
      noHp: json['no_hp'] ?? '-',
      email: json['email'],
      statusRegistrasi: json['status_registrasi'] ?? 'pending',
      fotoIdentitas: json['foto_identitas'],
    );
  }
}