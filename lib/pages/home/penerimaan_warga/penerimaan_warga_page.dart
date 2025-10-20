// penerimaan_warga_page.dart
import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class PenerimaanWargaPage extends StatefulWidget {
  const PenerimaanWargaPage({super.key});

  @override
  State<PenerimaanWargaPage> createState() => _PenerimaanWargaPageState();
}

class _PenerimaanWargaPageState extends State<PenerimaanWargaPage> {
  int currentPage = 1;
  final int itemsPerPage = 10;

  final List<Map<String, String>> wargaList = List.generate(20, (index) {
    return {
      'nama': 'Nama Warga ${index + 1}',
      'nim': '12${index + 10}',
    };
  });

  @override
  Widget build(BuildContext context) {
    final start = (currentPage - 1) * itemsPerPage;
    final end = (start + itemsPerPage < wargaList.length)
        ? start + itemsPerPage
        : wargaList.length;
    final displayedItems = wargaList.sublist(start, end);
    final totalPages = (wargaList.length / itemsPerPage).ceil();

    return PageLayout(
      title: 'Penerimaan Warga',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Tombol Filter
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.filter_alt, color: Colors.white),
                label: const Text(""),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tabel
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: DataTable(
                headingRowColor:
                    MaterialStateProperty.all(Colors.grey.shade100),
                columns: const [
                  DataColumn(
                    label: Text(
                      'No',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Nama',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'NIM',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: List.generate(displayedItems.length, (index) {
                  final item = displayedItems[index];
                  return DataRow(cells: [
                    DataCell(Text('${start + index + 1}')),
                    DataCell(Text(item['nama']!)),
                    DataCell(Text(item['nim']!)),
                  ]);
                }),
              ),
            ),

            const SizedBox(height: 20),

            // Pagination
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: currentPage > 1
                      ? () => setState(() => currentPage--)
                      : null,
                  icon: const Icon(Icons.chevron_left),
                ),
                for (int i = 1; i <= totalPages; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: () => setState(() => currentPage = i),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: i == currentPage
                            ? const Color(0xFF6C63FF)
                            : Colors.grey.shade200,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: const Size(36, 36),
                      ),
                      child: Text(
                        '$i',
                        style: TextStyle(
                          color: i == currentPage
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                IconButton(
                  onPressed: currentPage < totalPages
                      ? () => setState(() => currentPage++)
                      : null,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
