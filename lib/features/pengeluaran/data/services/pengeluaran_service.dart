import '../models/pengeluaran_model.dart';

class PengeluaranService {
  // Simulasi database/API
  final List<Pengeluaran> _dummyData = [
    Pengeluaran(
      id: '1',
      nama: "Kerja Bakti",
      jenisPengeluaran: "Kegiatan Warga",
      tanggal: DateTime(2025, 10, 19),
      nominal: 100000,
    ),
    Pengeluaran(
      id: '2',
      nama: "Beli Lampu Jalan",
      jenisPengeluaran: "Pemeliharaan Fasilitas",
      tanggal: DateTime(2025, 10, 02),
      nominal: 50000,
    ),
  ];

  // Mengambil semua data
  List<Pengeluaran> fetchAll() {
    // Di dunia nyata, di sini kita pakai 'await http.get(...)'
    return _dummyData;
  }

  // Menambah data
  void create(Pengeluaran data) {
    // Di dunia nyata, di sini kita pakai 'await http.post(...)'
    _dummyData.add(data);
  }
}