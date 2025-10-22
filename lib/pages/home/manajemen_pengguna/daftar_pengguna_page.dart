import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class DaftarPenggunaPage extends StatefulWidget {
  const DaftarPenggunaPage({super.key});

  @override
  State<DaftarPenggunaPage> createState() => _DaftarPenggunaPageState();
}

class _DaftarPenggunaPageState extends State<DaftarPenggunaPage> {
  int currentPage = 0;
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
          child: SingleChildScrollView(
            child: Container(
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

                  // ================= TABLE =================
                  Table(
                    border: const TableBorder(
                      horizontalInside: BorderSide(
                        width: 0.5,
                        color: Colors.grey,
                      ),
                    ),
                    columnWidths: const {
                      0: FlexColumnWidth(0.8), // 💡 lebih lebar agar tidak turun
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                    },
                    children: [
                      const TableRow(
                        decoration: BoxDecoration(
                          color: Color(0xFFF7F8FA),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center( // 💡 rata tengah untuk kolom NO
                              child: Text(
                                'NO',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'NAMA',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'EMAIL',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),

                      // ====== DATA ROWS ======
                      ...currentData.map(
                            (item) => TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(item['no']!), // 💡 rata tengah juga
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(item['nama']!),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(item['email']!),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ================= PAGINATION =================
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
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
      ),
    );
  }
}
