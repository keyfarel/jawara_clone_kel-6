class Pengeluaran {
  final String id;
  final String nama;
  final String jenisPengeluaran;
  final DateTime tanggal;
  final double nominal;
  final String? buktiPath; // Untuk fitur upload foto nanti

  Pengeluaran({
    required this.id,
    required this.nama,
    required this.jenisPengeluaran,
    required this.tanggal,
    required this.nominal,
    this.buktiPath,
  });
}