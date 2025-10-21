import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/layouts/pages_layout.dart';
import '../../../models/semua_pengeluaran_model.dart';

class SemuaPengeluaranPage extends StatefulWidget {
  const SemuaPengeluaranPage({super.key});

  @override
  State<SemuaPengeluaranPage> createState() => _SemuaPengeluaranPageState();
}

class _SemuaPengeluaranPageState extends State<SemuaPengeluaranPage> {
  List<Pengeluaran> daftarPengeluaran = [
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

  String? selectedJenis; // untuk filter

  final NumberFormat currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  String formatTanggal(DateTime date) {
    try {
      return DateFormat('dd MMM yyyy HH:mm', 'id_ID').format(date);
    } catch (_) {
      return DateFormat('dd MMM yyyy HH:mm').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter jika jenis dipilih
    final filteredList = selectedJenis == null
        ? daftarPengeluaran
        : daftarPengeluaran
            .where((p) => p.jenisPengeluaran == selectedJenis)
            .toList();

    return PageLayout(
      title: "Semua Pengeluaran",
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_alt),
          onPressed: () => _showFilterDialog(context),
        ),
        TextButton.icon(
          onPressed: () {
            // TODO: Implementasi cetak PDF
          },
          icon: const Icon(Icons.picture_as_pdf, color: Colors.black87),
          label: const Text(
            "Cetak PDF",
            style: TextStyle(color: Colors.black87),
          ),
        ),
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigasi ke tambah pengeluaran
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          final pengeluaran = filteredList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nomor urut
                  SizedBox(
                    width: 30,
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Detail Pengeluaran
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pengeluaran.nama,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 10,
                          runSpacing: 4,
                          children: [
                            _infoChip(
                              pengeluaran.jenisPengeluaran,
                              Colors.red[100]!,
                              Colors.red[800]!,
                            ),
                            _infoText("Tanggal", formatTanggal(pengeluaran.tanggal)),
                            _infoText("Nominal",
                                currencyFormatter.format(pengeluaran.nominal)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Tombol aksi (edit/hapus)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'edit') {
                        // TODO: aksi edit
                      } else if (value == 'hapus') {
                        // TODO: aksi hapus
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
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
    );
  }

  // === FILTER DIALOG ===
  void _showFilterDialog(BuildContext context) {
    String? tempJenis = selectedJenis;

    final jenisList =
        daftarPengeluaran.map((p) => p.jenisPengeluaran).toSet().toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filter Pengeluaran"),
          content: DropdownButtonFormField<String>(
            value: tempJenis,
            items: jenisList
                .map((jenis) => DropdownMenuItem(
                      value: jenis,
                      child: Text(jenis),
                    ))
                .toList(),
            onChanged: (val) {
              tempJenis = val;
            },
            decoration: const InputDecoration(
              labelText: "Pilih Jenis Pengeluaran",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedJenis = null;
                });
                Navigator.pop(context);
              },
              child: const Text("Reset"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              onPressed: () {
                setState(() {
                  selectedJenis = tempJenis;
                });
                Navigator.pop(context);
              },
              child: const Text("Terapkan"),
            ),
          ],
        );
      },
    );
  }

  // === UTILITAS ===
  Widget _infoChip(String value, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        value,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _infoText(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }
}
