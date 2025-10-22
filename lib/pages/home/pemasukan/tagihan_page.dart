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
      namaKeluarga: "Keluarga Somad",
      statusKeluarga: "Aktif",
      iuran: "Mingguan",
      kodeTagihan: "IR175458A501",
      nominal: "Rp 10,00",
      periode: "8 Oktober 2025",
      status: "Belum Dibayar",
    ),
    Tagihan(
      namaKeluarga: "Keluarga Somad",
      statusKeluarga: "Aktif",
      iuran: "Mingguan",
      kodeTagihan: "IR185702KX01",
      nominal: "Rp 10,00",
      periode: "15 Oktober 2025",
      status: "Belum Dibayar",
    ),
    Tagihan(
      namaKeluarga: "Keluarga Somad",
      statusKeluarga: "Aktif",
      iuran: "Mingguan",
      kodeTagihan: "IR223936NM01",
      nominal: "Rp 10,00",
      periode: "30 September 2025",
      status: "Sudah Dibayar",
    ),
  ];

  String? selectedStatus;
  int currentPage = 1;
  final int itemsPerPage = 2;

  @override
  Widget build(BuildContext context) {
    final filteredList = selectedStatus == null
        ? daftarTagihan
        : daftarTagihan.where((t) => t.status == selectedStatus).toList();

    final totalPages = (filteredList.length / itemsPerPage).ceil();
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage) > filteredList.length
        ? filteredList.length
        : (startIndex + itemsPerPage);
    final paginatedList = filteredList.sublist(startIndex, endIndex);

    return PageLayout(
      title: "Tagihan - Daftar",
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_alt),
          onPressed: () => _showFilterDialog(context),
        ),
        TextButton.icon(
          onPressed: () {
            // TODO: Cetak PDF
          },
          icon: const Icon(Icons.picture_as_pdf, color: Colors.black87),
          label: const Text(
            "Cetak PDF",
            style: TextStyle(color: Colors.black87),
          ),
        ),
      ],
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: paginatedList.length,
              itemBuilder: (context, index) {
                final tagihan = paginatedList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Header ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "${startIndex + index + 1}. ${tagihan.namaKeluarga}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
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
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 8),

                        // --- Info Tabel ---
                        Table(
                          columnWidths: const {
                            0: FixedColumnWidth(140),
                            1: FixedColumnWidth(20),
                            2: FlexColumnWidth(),
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            _buildTableRow("Status Keluarga",
                                tagihan.statusKeluarga, Colors.green),
                            _buildTableRow("Jenis Iuran", tagihan.iuran),
                            _buildTableRow("Kode Tagihan", tagihan.kodeTagihan),
                            _buildTableRow("Nominal", tagihan.nominal),
                            _buildTableRow("Periode", tagihan.periode),
                          ],
                        ),
                      ],
                    ),
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

  TableRow _buildTableRow(String label, String value, [Color? accent]) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Text(":", textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: accent ?? Colors.black87,
              fontWeight: accent != null ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

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
            onChanged: (val) => tempStatus = val,
            decoration: const InputDecoration(
              labelText: "Pilih Status Tagihan",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() => selectedStatus = null);
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
                  currentPage = 1;
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
}
