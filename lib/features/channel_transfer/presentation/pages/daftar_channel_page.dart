import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../layouts/pages_layout.dart';
import '../../controllers/channel_controller.dart';
import '../../data/models/channel_model.dart';

class DaftarChannelPage extends StatefulWidget {
  const DaftarChannelPage({super.key});

  @override
  State<DaftarChannelPage> createState() => _DaftarChannelPageState();
}

class _DaftarChannelPageState extends State<DaftarChannelPage> {
  int currentPage = 1;
  final int itemsPerPage = 5; // Tampilkan 5 item per halaman

  @override
  void initState() {
    super.initState();
    // Load data saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChannelController>().loadChannels();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ChannelController>();
    final List<ChannelModel> allChannels = controller.channels;

    // Pagination Logic Client Side
    final int totalPages = (allChannels.length / itemsPerPage).ceil();
    // Reset page jika data berubah drastis
    if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
    if (totalPages == 0) currentPage = 1;

    final int startIndex = (currentPage - 1) * itemsPerPage;
    final int endIndex = (startIndex + itemsPerPage < allChannels.length)
        ? startIndex + itemsPerPage
        : allChannels.length;
    
    final List<ChannelModel> paginatedList = allChannels.isNotEmpty 
        ? allChannels.sublist(startIndex, endIndex) 
        : [];

    return PageLayout(
      title: 'Daftar Channel Transfer',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Konten Utama
            Expanded(
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : controller.errorMessage != null
                      ? Center(child: Text('Error: ${controller.errorMessage}'))
                      : allChannels.isEmpty
                          ? const Center(child: Text("Belum ada channel pembayaran"))
                          : ListView.builder(
                              itemCount: paginatedList.length,
                              itemBuilder: (context, index) {
                                final channel = paginatedList[index];
                                // Hitung nomor urut global
                                final int displayNo = startIndex + index + 1;
                                final globalIndex = startIndex + index;

                                return Transform.translate(
                                  offset: Offset(0, globalIndex * 2.0), // Animasi ringan
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
                                              "$displayNo",
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  channel.channelName,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                _buildInfoRow('Tipe', _formatType(channel.type)),
                                                _buildInfoRow('No. Rek', channel.accountNumber),
                                                _buildInfoRow('A/N', channel.accountName),
                                                // Status Aktif
                                                const SizedBox(height: 4),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: channel.isActive ? Colors.green.shade50 : Colors.red.shade50,
                                                    borderRadius: BorderRadius.circular(4),
                                                    border: Border.all(
                                                      color: channel.isActive ? Colors.green : Colors.red,
                                                      width: 0.5
                                                    )
                                                  ),
                                                  child: Text(
                                                    channel.isActive ? "Aktif" : "Non-Aktif",
                                                    style: TextStyle(
                                                      fontSize: 10, 
                                                      color: channel.isActive ? Colors.green : Colors.red,
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),

                                          // 🔹 Popup Menu Aksi
                                          PopupMenuButton<String>(
                                            icon: const Icon(Icons.more_vert),
                                            onSelected: (value) {
                                              if (value == 'detail') {
                                                _showDetailDialog(channel);
                                              } else if (value == 'hapus') {
                                                 // Logic hapus lokal (karena belum ada API delete)
                                                 _showSnack("Fitur hapus belum tersedia di API");
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
            if (totalPages > 1) ...[
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 1; i <= totalPages; i++)
                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 4),
                             child: ElevatedButton(
                               style: ElevatedButton.styleFrom(
                                 backgroundColor: i == currentPage
                                     ? Colors.blue
                                     : Colors.grey[200],
                                 foregroundColor: i == currentPage
                                     ? Colors.white
                                     : Colors.black87,
                                 minimumSize: const Size(36, 36),
                                 padding: EdgeInsets.zero,
                               ),
                               onPressed: () => setState(() => currentPage = i),
                               child: Text('$i'),
                             ),
                           ),
                      ],
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
          ],
        ),
      ),
    );
  }

  // Helper format tipe (bank_transfer -> Bank Transfer)
  String _formatType(String raw) {
    return raw.replaceAll('_', ' ').toUpperCase();
  }

  // 🔹 Dialog Detail
  void _showDetailDialog(ChannelModel channel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail: ${channel.channelName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Tipe', _formatType(channel.type)),
            _buildInfoRow('No. Rek', channel.accountNumber),
            _buildInfoRow('A/N', channel.accountName),
            const SizedBox(height: 8),
            _buildInfoRow('Catatan', channel.notes ?? '-'),
            const SizedBox(height: 12),
            if (channel.qrCode != null)
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   const Text("QR Code:", style: TextStyle(fontWeight: FontWeight.bold)),
                   const SizedBox(height: 4),
                   const Text("[Gambar QR Code]", style: TextStyle(color: Colors.grey)), 
                   // Nanti bisa diganti Image.network jika URL sudah lengkap
                 ],
               )
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
        crossAxisAlignment: CrossAxisAlignment.start,
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