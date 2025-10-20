import 'package:flutter/material.dart';
import '../../../models/pengeluaran_model.dart';

class PengeluaranDaftarPage extends StatefulWidget {
  const PengeluaranDaftarPage({super.key});

  @override
  State<PengeluaranDaftarPage> createState() => _PengeluaranDaftarPageState();
}

class _PengeluaranDaftarPageState extends State<PengeluaranDaftarPage> {
  List<Pengeluaran> daftarPengeluaran = [
    Pengeluaran(
      nama: "Kerja Bakti",
      jenisPengeluaran: "Kegiatan Warga",
      tanggal: "19 Oktober 2025",
      nominal: "Rp 100.000,00",
    ),
    Pengeluaran(
      nama: "Kerja Bakti",
      jenisPengeluaran: "Pemeliharaan Fasilitas",
      tanggal: "19 Oktober 2025",
      nominal: "Rp 50.000,00",
    ),
    Pengeluaran(
      nama: "Arka",
      jenisPengeluaran: "Operasional RT/RW",
      tanggal: "17 Oktober 2025",
      nominal: "Rp 6,00",
    ),
    Pengeluaran(
      nama: "adsad",
      jenisPengeluaran: "Pemeliharaan Fasilitas",
      tanggal: "02 Oktober 2025",
      nominal: "Rp 2.112,00",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengeluaran'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Aksi filter
            },
          ),
          TextButton.icon(
            onPressed: () {
              // Aksi cetak PDF
            },
            icon: const Icon(Icons.picture_as_pdf, color: Colors.black),
            label: const Text(
              "Cetak PDF",
              style: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        itemCount: daftarPengeluaran.length,
        itemBuilder: (context, index) {
          final pengeluaran = daftarPengeluaran[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 2,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  // No
                  SizedBox(
                    width: 30,
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Detail utama
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pengeluaran.nama,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text("Jenis: ${pengeluaran.jenisPengeluaran}"),
                        Text("Tanggal: ${pengeluaran.tanggal}"),
                        Text("Nominal: ${pengeluaran.nominal}"),
                      ],
                    ),
                  ),

                  // Tombol aksi (3 titik)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'edit') {
                        // Aksi edit
                      } else if (value == 'hapus') {
                        // Aksi hapus
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'hapus',
                        child: Text('Hapus'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke tambah pengeluaran
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
