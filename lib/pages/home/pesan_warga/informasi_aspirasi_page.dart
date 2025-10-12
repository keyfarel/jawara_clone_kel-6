// file: informasi_aspirasi_page.dart
import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class InformasiAspirasiPage extends StatefulWidget {
  const InformasiAspirasiPage({super.key});

  @override
  State<InformasiAspirasiPage> createState() => _InformasiAspirasiPageState();
}

class _InformasiAspirasiPageState extends State<InformasiAspirasiPage> {
  final List<Map<String, String>> aspirasiList = const [
    {
      "no": "1",
      "pengirim": "Habibie Ed Dien",
      "judul": "Tes",
      "status": "Pending",
      "tanggal": "28 September 2025",
    },
    {
      "no": "2",
      "pengirim": "Andi Saputra",
      "judul": "Perbaikan Lampu Jalan",
      "status": "Selesai",
      "tanggal": "10 Oktober 2025",
    },
    {
      "no": "3",
      "pengirim": "Siti Rohani",
      "judul": "Pengajuan Taman Bermain",
      "status": "Diproses",
      "tanggal": "5 Oktober 2025",
    },
  ];

  int currentPage = 1;
  final int itemsPerPage = 2;

  @override
  Widget build(BuildContext context) {
    final int totalPages = (aspirasiList.length / itemsPerPage).ceil();
    final int startIndex = (currentPage - 1) * itemsPerPage;
    final int endIndex = (startIndex + itemsPerPage < aspirasiList.length)
        ? startIndex + itemsPerPage
        : aspirasiList.length;
    final List<Map<String, String>> paginatedList =
        aspirasiList.sublist(startIndex, endIndex);

    return PageLayout(
      title: 'Informasi Aspirasi',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Header Table
            Container(
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: const [
                  _HeaderCell('No', flex: 1),
                  _HeaderCell('Pengirim', flex: 3),
                  _HeaderCell('Judul', flex: 3),
                  _HeaderCell('Status', flex: 2),
                  _HeaderCell('Tanggal Dibuat', flex: 3),
                  _HeaderCell('Aksi', flex: 2),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // 🔹 Data Rows
            Expanded(
              child: ListView.builder(
                itemCount: paginatedList.length,
                itemBuilder: (context, index) {
                  final aspirasi = paginatedList[index];
                  final globalIndex = startIndex + index;

                  return Transform.translate(
                    offset: Offset(0, globalIndex * 2.0),
                    child: Card(
                      elevation: 3,
                      shadowColor: Colors.grey.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        child: Row(
                          children: [
                            _DataCell(aspirasi['no']!, flex: 1),
                            _DataCell(aspirasi['pengirim']!, flex: 3),
                            _DataCell(aspirasi['judul']!, flex: 3),
                            _StatusBadge(aspirasi['status']!, flex: 2),
                            _DataCell(aspirasi['tanggal']!, flex: 3),
                            // 🔹 Aksi Button
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.visibility,
                                        color: Colors.indigo),
                                    tooltip: 'Lihat Detail',
                                    onPressed: () {
                                      // TODO: Tambahkan navigasi ke detail aspirasi
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // 🔹 Pagination
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: currentPage > 1
                      ? () => setState(() => currentPage--)
                      : null,
                ),
                for (int i = 1; i <= totalPages; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            i == currentPage ? Colors.indigo : Colors.grey[200],
                        foregroundColor:
                            i == currentPage ? Colors.white : Colors.black87,
                        minimumSize: const Size(36, 36),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () => setState(() => currentPage = i),
                      child: Text('$i'),
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
          ],
        ),
      ),
    );
  }
}

// 🔹 Header Cell
class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;
  const _HeaderCell(this.text, {required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.indigo,
        ),
      ),
    );
  }
}

// 🔹 Data Cell
class _DataCell extends StatelessWidget {
  final String text;
  final int flex;
  const _DataCell(this.text, {required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
        ),
      ),
    );
  }
}

// 🔹 Status Badge
class _StatusBadge extends StatelessWidget {
  final String status;
  final int flex;
  const _StatusBadge(this.status, {required this.flex});

  Color _getColor() {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'diproses':
        return Colors.blue;
      case 'selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _getColor(), width: 1),
        ),
        child: Text(
          status,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _getColor(),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
