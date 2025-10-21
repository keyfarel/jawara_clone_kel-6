import 'package:flutter/material.dart';
import 'package:myapp/layouts/pages_layout.dart';
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
      status: "Sudah Dibayar",
    ),
  ];

  String? selectedStatus; // Filter berdasarkan status tagihan

  @override
  Widget build(BuildContext context) {
    // Filter daftar tagihan berdasarkan status
    final filteredList = selectedStatus == null
        ? daftarTagihan
        : daftarTagihan.where((t) => t.status == selectedStatus).toList();

    return PageLayout(
      title: "Tagihan - Daftar",
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          final tagihan = filteredList[index];
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
                            _infoChip(
                              tagihan.statusKeluarga,
                              Colors.green[100]!,
                              Colors.green[800]!,
                            ),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: tagihan.status == "Sudah Dibayar"
                          ? Colors.green[100]
                          : Colors.amber[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      tagihan.status,
                      style: TextStyle(
                        color: tagihan.status == "Sudah Dibayar"
                            ? Colors.green[800]
                            : Colors.amber[800],
                        fontWeight: FontWeight.w600,
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

  // === FILTER DIALOG ===
  void _showFilterDialog(BuildContext context) {
    String? tempStatus = selectedStatus;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filter Tagihan"),
          content: DropdownButtonFormField<String>(
            value: tempStatus,
            items: ["Belum Dibayar", "Sudah Dibayar"]
                .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    ))
                .toList(),
            onChanged: (val) {
              tempStatus = val;
            },
            decoration: const InputDecoration(
              labelText: "Pilih Status Tagihan",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedStatus = null;
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
                  selectedStatus = tempStatus;
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

  // === WIDGET UTILITAS ===
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
