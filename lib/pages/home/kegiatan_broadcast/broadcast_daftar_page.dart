import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class BroadcastDaftarPage extends StatefulWidget {
  const BroadcastDaftarPage({super.key});

  @override
  State<BroadcastDaftarPage> createState() => _BroadcastDaftarPageState();
}

class _BroadcastDaftarPageState extends State<BroadcastDaftarPage> {
  final List<Map<String, String>> daftarBroadcast = const [
    {'pengirim': 'Admin Jawara', 'judul': 'Gotong Royong 1'},
    {'pengirim': 'Admin Jawara', 'judul': 'Gotong Royong 2'},
    {'pengirim': 'Admin Jawara', 'judul': 'Gotong Royong 3'},
    {'pengirim': 'Admin Jawara', 'judul': 'Gotong Royong 4'},
    {'pengirim': 'Admin Jawara', 'judul': 'Gotong Royong 5'},
    {'pengirim': 'Admin Jawara', 'judul': 'Gotong Royong 6'},
    {'pengirim': 'Admin Jawara', 'judul': 'Gotong Royong 7'},
    {'pengirim': 'Admin Jawara', 'judul': 'Gotong Royong 8'},
    {'pengirim': 'Admin Jawara', 'judul': 'Gotong Royong 9'},
    {'pengirim': 'Admin Jawara', 'judul': 'Gotong Royong 10'},
  ];

  int currentPage = 0; // halaman aktif
  final int perPage = 5;

  // Fungsi membagi data ke halaman
  List<List<Map<String, String>>> _paginateData(List<Map<String, String>> data, int perPage) {
    List<List<Map<String, String>>> pages = [];
    for (int i = 0; i < data.length; i += perPage) {
      pages.add(data.sublist(i, i + perPage > data.length ? data.length : i + perPage));
    }
    return pages;
  }

  // Fungsi membuat satu baris tabel
  Widget _buildRow(int no, String pengirim, String judul) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(no.toString(), textAlign: TextAlign.center)),
          Expanded(flex: 3, child: Text(pengirim, textAlign: TextAlign.center)),
          Expanded(flex: 3, child: Text(judul, textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  // Fungsi membuat satu tabel (halaman)
  Widget _buildTablePage(List<Map<String, String>> pageItems, int pageIndex) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
        mainAxisSize: MainAxisSize.min, // tinggi tabel sesuai isi
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Row(
              children: [
                Expanded(flex: 1, child: Text('NO', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 3, child: Text('PENGIRIM', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 3, child: Text('JUDUL', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),

          const Divider(height: 1, color: Colors.grey),

          // Isi tabel
          for (int i = 0; i < pageItems.length; i++)
            _buildRow(
              pageIndex * perPage + i + 1,
              pageItems[i]['pengirim']!,
              pageItems[i]['judul']!,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paginatedData = _paginateData(daftarBroadcast, perPage);

    return PageLayout(
      title: 'Broadcast Daftar',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tombol filter
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.filter_list),
              label: const Text('Filter'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Tabel yang berubah berdasarkan halaman aktif
            _buildTablePage(paginatedData[currentPage], currentPage),

            const SizedBox(height: 16),

            // Tombol pagination
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  color: Colors.grey,
                  onPressed: currentPage > 0
                      ? () {
                          setState(() {
                            currentPage--;
                          });
                        }
                      : null,
                ),
                for (int i = 0; i < paginatedData.length; i++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentPage = i;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: currentPage == i ? Colors.blueAccent : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: currentPage == i ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  color: Colors.grey,
                  onPressed: currentPage < paginatedData.length - 1
                      ? () {
                          setState(() {
                            currentPage++;
                          });
                        }
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
