import 'dart:math';
import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class DaftarPenggunaPage extends StatefulWidget {
  const DaftarPenggunaPage({super.key});

  @override
  State<DaftarPenggunaPage> createState() => _DaftarPenggunaPageState();
}

class _DaftarPenggunaPageState extends State<DaftarPenggunaPage> {
  int currentPage = 0; // Halaman aktif
  final int perPage = 5;

  final List<Map<String, String>> pengguna = [
    {'no': '1', 'nama': 'Rendha Putra Rahmadya', 'email': 'rendha@mail.com'},
    {'no': '2', 'nama': 'Bla', 'email': 'y@gmail.com'},
    {'no': '3', 'nama': 'Anti Micin', 'email': 'anti@mail.com'},
    {'no': '4', 'nama': 'Ijat4', 'email': 'ijat4@mail.com'},
    {'no': '5', 'nama': 'Ijat3', 'email': 'ijat3@mail.com'},
    {'no': '6', 'nama': 'Ijat2', 'email': 'ijat2@mail.com'},
    {'no': '7', 'nama': 'Afifah Khoirunnisa', 'email': 'afi@mail.com'},
    {'no': '8', 'nama': 'Raudhli Firdaus Naufal', 'email': 'raudhli@mail.com'},
    {'no': '9', 'nama': 'Varizky Naldiba Rimra', 'email': 'zel@mail.com'},
    {'no': '10', 'nama': 'Asdopar', 'email': 'asd@mail.com'},
  ];

  final Random _random = Random();

  @override
  Widget build(BuildContext context) {
    int startIndex = currentPage * perPage;
    int endIndex = (startIndex + perPage).clamp(0, pengguna.length);
    List<Map<String, String>> currentData = pengguna.sublist(startIndex, endIndex);
    int totalPages = (pengguna.length / perPage).ceil();

    return PageLayout(
      title: 'Daftar Pengguna',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: 800, // ✅ atur lebar maksimal card biar teks muat
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tombol Filter
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Icon(Icons.filter_alt, color: Colors.white),
                ),
                const SizedBox(height: 16),

                // ✅ Scroll horizontal untuk tabel
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 750, // lebar tabel
                    child: Table(
                      border: const TableBorder(
                        horizontalInside: BorderSide(
                          width: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      columnWidths: const {
                        0: FlexColumnWidth(0.6),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(2),
                        4: FlexColumnWidth(1.8),
                      },
                      children: [
                        const TableRow(
                          decoration: BoxDecoration(color: Color(0xFFF7F8FA)),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('NO', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('NAMA', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('EMAIL', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('STATUS REGISTRASI', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('AKSI', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        ...currentData.map(
                          (item) {
                            bool diterima = Random().nextBool();
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(item['no']!, textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(item['nama']!, textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(item['email']!, textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: diterima ? Colors.green[100] : Colors.red[100],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: Text(
                                      diterima ? 'Diterima' : 'Ditolak',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: diterima ? Colors.green[800] : Colors.red[800],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        tooltip: 'Detail',
                                        icon: const Icon(Icons.info, color: Colors.blueAccent),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        tooltip: 'Edit',
                                        icon: const Icon(Icons.edit, color: Colors.orangeAccent),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Pagination
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: currentPage > 0
                          ? () {
                              setState(() {
                                currentPage--;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Text(
                        '${currentPage + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      onPressed: currentPage < totalPages - 1
                          ? () {
                              setState(() {
                                currentPage++;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}