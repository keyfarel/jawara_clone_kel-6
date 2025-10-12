// file: daftar_channel_page.dart
import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class DaftarChannelPage extends StatefulWidget {
  const DaftarChannelPage({super.key});

  @override
  State<DaftarChannelPage> createState() => _DaftarChannelPageState();
}

class _DaftarChannelPageState extends State<DaftarChannelPage> {
  final List<Map<String, String>> channels = const [
    {
      "no": "1",
      "nama": "Transfer via BCA",
      "tipe": "Bank",
      "an": "RT Jawara Karangploso",
      "thumbnail": "-",
      "aksi": "..."
    },
    {
      "no": "2",
      "nama": "Gopay Ketua RT",
      "tipe": "E-Wallet",
      "an": "Budi Santoso",
      "thumbnail": "-",
      "aksi": "..."
    },
    {
      "no": "3",
      "nama": "QRIS Resmi RT 08",
      "tipe": "QRIS",
      "an": "RW 08 Karangploso",
      "thumbnail": "-",
      "aksi": "..."
    },
    {
      "no": "4",
      "nama": "Dana Bendahara RW",
      "tipe": "E-Wallet",
      "an": "Siti Rohani",
      "thumbnail": "-",
      "aksi": "..."
    },
    {
      "no": "5",
      "nama": "Rekening BRI RT 08",
      "tipe": "Bank",
      "an": "RT 08 Karangploso",
      "thumbnail": "-",
      "aksi": "..."
    },
  ];

  int currentPage = 1;
  final int itemsPerPage = 2;

  @override
  Widget build(BuildContext context) {
    final int totalPages = (channels.length / itemsPerPage).ceil();
    final int startIndex = (currentPage - 1) * itemsPerPage;
    final int endIndex = (startIndex + itemsPerPage < channels.length)
        ? startIndex + itemsPerPage
        : channels.length;
    final List<Map<String, String>> paginatedList =
        channels.sublist(startIndex, endIndex);

    return PageLayout(
      title: 'Daftar Channel Transfer',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: paginatedList.length,
                itemBuilder: (context, index) {
                  final channel = paginatedList[index];
                  final globalIndex = startIndex + index;

                  return Transform.translate(
                    offset: Offset(0, globalIndex * 2.0),
                    child: Card(
                      elevation: 4,
                      shadowColor: Colors.grey.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nomor
                            Container(
                              width: 36,
                              height: 36,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                channel['no']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Detail
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    channel['nama']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildInfoRow('Tipe', channel['tipe']!),
                                  _buildInfoRow('A/N', channel['an']!),
                                  _buildInfoRow(
                                      'Thumbnail', channel['thumbnail']!),
                                ],
                              ),
                            ),

                            // 🔹 Popup Menu Aksi
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert),
                              onSelected: (value) {
                                if (value == 'detail') {
                                  _showDetailDialog(channel);
                                } else if (value == 'edit') {
                                  _showSnack('Edit ${channel['nama']}');
                                } else if (value == 'hapus') {
                                  _confirmDelete(channel);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'detail',
                                  child: Row(
                                    children: [
                                      Icon(Icons.info_outline,
                                          size: 20, color: Colors.blue),
                                      SizedBox(width: 8),
                                      Text('Detail'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit,
                                          size: 20, color: Colors.orange),
                                      SizedBox(width: 8),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'hapus',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_outline,
                                          size: 20, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Hapus'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // 🔹 Pagination Controls
            const SizedBox(height: 8),
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
                            i == currentPage ? Colors.blue : Colors.grey[200],
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

  // 🔹 Dialog Detail
  void _showDetailDialog(Map<String, String> channel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail: ${channel['nama']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Tipe', channel['tipe']!),
            _buildInfoRow('A/N', channel['an']!),
            _buildInfoRow('Thumbnail', channel['thumbnail']!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  // 🔹 Konfirmasi Hapus
  void _confirmDelete(Map<String, String> channel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Yakin ingin menghapus "${channel['nama']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                channels.remove(channel);
              });
              Navigator.pop(context);
              _showSnack('Channel "${channel['nama']}" telah dihapus.');
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Snackbar umum
  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
