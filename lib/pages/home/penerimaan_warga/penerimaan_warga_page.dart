import 'dart:math';
import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class PenerimaanWargaPage extends StatefulWidget {
  const PenerimaanWargaPage({super.key});

  @override
  State<PenerimaanWargaPage> createState() => _PenerimaanWargaPageState();
}

class _PenerimaanWargaPageState extends State<PenerimaanWargaPage> {
  final Random _random = Random();

  int currentPage = 1;
  final int itemsPerPage = 10;

  late final List<Map<String, dynamic>> wargaList = List.generate(20, (index) {
    final jenisKelamin = _random.nextBool() ? 'L' : 'P';
    final fotoUrl = 'https://picsum.photos/seed/${index + 1}/100/100';
    final status = _random.nextBool() ? 'Diterima' : 'Menunggu';

    return {
      'nama': 'Nama Warga ${index + 1}',
      'nik': '12${index + 10}',
      'email': 'email${index + 1}@mail.com',
      'jk': jenisKelamin,
      'foto': fotoUrl,
      'status': status,
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
                label: const Text("Filter"),
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

            // TABEL
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor:
                      MaterialStateProperty.all(Colors.grey.shade100),
                  columns: const [
                    DataColumn(label: Center(child: Text('No', style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Center(child: Text('Nama', style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Center(child: Text('NIK', style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Center(child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Center(child: Text('Jenis Kelamin', style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Center(child: Text('Foto Identitas', style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Center(child: Text('Status Registrasi', style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Center(child: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold)))),
                  ],
                  rows: List.generate(displayedItems.length, (index) {
                    final item = displayedItems[index];
                    final isDiterima = item['status'] == 'Diterima';

                    return DataRow(
                      cells: [
                        DataCell(Text('${start + index + 1}')),
                        DataCell(Text(item['nama']!)),
                        DataCell(Text(item['nik']!)),
                        DataCell(Text(item['email']!)),
                        DataCell(Text(item['jk']!)),

                        // FOTO
                        DataCell(
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              item['foto']!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.person,
                                      size: 40, color: Colors.grey),
                            ),
                          ),
                        ),

                        // STATUS
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isDiterima
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item['status']!,
                              style: TextStyle(
                                color: isDiterima
                                    ? Colors.green[700]
                                    : Colors.orange[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        // AKSI
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.info,
                                    color: Colors.blueAccent),
                                tooltip: 'Detail',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Detail ${item['nama']} ditekan'),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.orangeAccent),
                                tooltip: 'Edit',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Edit ${item['nama']} ditekan'),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent),
                                tooltip: 'Hapus',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Hapus ${item['nama']} ditekan'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // PAGINATION
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
