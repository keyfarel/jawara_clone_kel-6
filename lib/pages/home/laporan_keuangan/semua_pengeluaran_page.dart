import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/semua_pengeluaran_model.dart';

class SemuaPengeluaranPage extends StatelessWidget {
  const SemuaPengeluaranPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Contoh data dummy
    final List<Pengeluaran> daftarPengeluaran = [
      Pengeluaran(
        id: '1',
        nama: 'Kerja Bakti',
        jenisPengeluaran: 'Pemeliharaan Fasilitas',
        tanggal: DateTime(2025, 10, 19, 20, 26),
        nominal: 50000,
      ),
      Pengeluaran(
        id: '2',
        nama: 'Kerja Bakti',
        jenisPengeluaran: 'Kegiatan Warga',
        tanggal: DateTime(2025, 10, 19, 20, 26),
        nominal: 100000,
      ),
      Pengeluaran(
        id: '3',
        nama: 'Arka',
        jenisPengeluaran: 'Operasional RT/RW',
        tanggal: DateTime(2025, 10, 17, 2, 31),
        nominal: 6,
      ),
      Pengeluaran(
        id: '4',
        nama: 'adsad',
        jenisPengeluaran: 'Pemeliharaan Fasilitas',
        tanggal: DateTime(2025, 10, 10, 1, 8),
        nominal: 2112,
      ),
    ];

    // --- Format uang aman tanpa error locale ---
    final NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'en_US', symbol: 'Rp ', decimalDigits: 0);

    // --- Format tanggal aman tanpa error locale ---
    String formatTanggal(DateTime date) {
      try {
        return DateFormat('dd MMM yyyy HH:mm', 'id_ID').format(date);
      } catch (e) {
        // fallback jika 'id_ID' tidak tersedia
        return DateFormat('dd MMM yyyy HH:mm').format(date);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Semua Pengeluaran',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFFF7F7F7),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              itemCount: daftarPengeluaran.length,
              itemBuilder: (context, index) {
                final pengeluaran = daftarPengeluaran[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Panah merah di sisi kiri
                      Container(
                        width: 50,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_upward,
                          color: Colors.redAccent,
                          size: 28,
                        ),
                      ),

                      // Isi pengeluaran
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nama dan nominal
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      pengeluaran.nama,
                                      style: TextStyle(
                                        fontSize: isMobile ? 16 : 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    currencyFormatter
                                        .format(pengeluaran.nominal),
                                    style: TextStyle(
                                      fontSize: isMobile ? 15 : 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              // Jenis pengeluaran
                              Text(
                                pengeluaran.jenisPengeluaran,
                                style: TextStyle(
                                  fontSize: isMobile ? 14 : 15,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Tanggal
                              Text(
                                formatTanggal(pengeluaran.tanggal),
                                style: TextStyle(
                                  fontSize: isMobile ? 13 : 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Tombol aksi (...)
                      Padding(
                        padding: const EdgeInsets.only(right: 12, top: 8),
                        child: IconButton(
                          icon: const Icon(Icons.more_horiz,
                              color: Colors.grey, size: 22),
                          onPressed: () {
                            // Tambahkan aksi (edit, hapus, detail)
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
