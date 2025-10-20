import 'package:flutter/material.dart';
import '../../../models/tagihan_model.dart';

class TagihanDaftarPage extends StatefulWidget {
  const TagihanDaftarPage({super.key});

  @override
  State<TagihanDaftarPage> createState() => _TagihanDaftarPageState();
}

class _TagihanDaftarPageState extends State<TagihanDaftarPage> {
  List<Tagihan> daftarTagihan = [
    Tagihan(
      namaKeluarga: "Keluarga Habibie Ed Dien",
      statusKeluarga: "Aktif",
      iuran: "Mingguan",
      kodeTagihan: "IR175458A501",
      nominal: "Rp 10,00",
      periode: "8 Oktober 2025",
      status: "Belum Dibayar",
    ),
    Tagihan(
      namaKeluarga: "Keluarga Habibie Ed Dien",
      statusKeluarga: "Aktif",
      iuran: "Mingguan",
      kodeTagihan: "IR185702KX01",
      nominal: "Rp 10,00",
      periode: "15 Oktober 2025",
      status: "Belum Dibayar",
    ),
    Tagihan(
      namaKeluarga: "Keluarga Habibie Ed Dien",
      statusKeluarga: "Aktif",
      iuran: "Mingguan",
      kodeTagihan: "IR223936NM01",
      nominal: "Rp 10,00",
      periode: "30 September 2025",
      status: "Belum Dibayar",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Tagihan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
          TextButton.icon(
            onPressed: () {},
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
        itemCount: daftarTagihan.length,
        itemBuilder: (context, index) {
          final tagihan = daftarTagihan[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 2,
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

                  // Detail Tagihan
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tagihan.namaKeluarga,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 10,
                          runSpacing: 4,
                          children: [
                            _infoChip("Status", tagihan.statusKeluarga,
                                Colors.green[100]!, Colors.green[800]!),
                            _infoText("Iuran", tagihan.iuran),
                            _infoText("Kode", tagihan.kodeTagihan),
                            _infoText("Nominal", tagihan.nominal),
                            _infoText("Periode", tagihan.periode),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Status Chip
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      tagihan.status,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoChip(String label, String value, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(value,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
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
