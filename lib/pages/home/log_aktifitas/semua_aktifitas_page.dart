import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class Aktivitas {
  final String deskripsi;
  final String aktor;
  final String tanggal;

  Aktivitas({
    required this.deskripsi,
    required this.aktor,
    required this.tanggal,
  });
}

class SemuaAktifitasPage extends StatefulWidget {
  const SemuaAktifitasPage({super.key});

  @override
  State<SemuaAktifitasPage> createState() => _SemuaAktifitasPageState();
}

class _SemuaAktifitasPageState extends State<SemuaAktifitasPage> {
  List<Aktivitas> daftarAktivitas = [
    Aktivitas(
      deskripsi: "Menambahkan akun : dor sebagai secretary",
      aktor: "Admin Jawara",
      tanggal: "22 Oktober 2025",
    ),
    Aktivitas(
      deskripsi: "Menambahkan akun : aku sebagai neighborhood_head",
      aktor: "Admin Jawara",
      tanggal: "22 Oktober 2025",
    ),
    Aktivitas(
      deskripsi:
          "Menugaskan tagihan : Bersih Desa periode Oktober 2025 sebesar Rp. 200.000",
      aktor: "Admin Jawara",
      tanggal: "21 Oktober 2025",
    ),
    Aktivitas(
      deskripsi: "Membuat broadcast baru: Pengumuman",
      aktor: "Admin Jawara",
      tanggal: "21 Oktober 2025",
    ),
    Aktivitas(
      deskripsi: "Mendownload laporan keuangan",
      aktor: "Admin Jawara",
      tanggal: "21 Oktober 2025",
    ),
    Aktivitas(
      deskripsi: "Menambahkan iuran baru: asad",
      aktor: "Admin Jawara",
      tanggal: "21 Oktober 2025",
    ),
  ];

  int currentPage = 1;
  final int itemsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    final totalPages = (daftarAktivitas.length / itemsPerPage).ceil();
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage) > daftarAktivitas.length
        ? daftarAktivitas.length
        : (startIndex + itemsPerPage);
    final paginatedList = daftarAktivitas.sublist(startIndex, endIndex);

    return PageLayout(
      title: "Semua Aktivitas",
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: paginatedList.length,
              itemBuilder: (context, index) {
                final aktivitas = paginatedList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Baris atas: aktor dan tanggal
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            aktivitas.aktor,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            aktivitas.tanggal,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 12, color: Colors.grey),
                      // Deskripsi
                      Text(
                        aktivitas.deskripsi,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // --- Pagination ---
          if (totalPages > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 16, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: currentPage > 1
                        ? () => setState(() => currentPage--)
                        : null,
                  ),
                  Text(
                    "$currentPage",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: currentPage < totalPages
                        ? () => setState(() => currentPage++)
                        : null,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}