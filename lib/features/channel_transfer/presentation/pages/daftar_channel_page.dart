import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../layouts/pages_layout.dart';
import '../../controllers/channel_controller.dart';
import '../../data/models/channel_model.dart';
import '../../data/services/channel_service.dart'; // Import service langsung utk detail (opsional, bisa via controller)

class DaftarChannelPage extends StatefulWidget {
  const DaftarChannelPage({super.key});

  @override
  State<DaftarChannelPage> createState() => _DaftarChannelPageState();
}

class _DaftarChannelPageState extends State<DaftarChannelPage> {
  int currentPage = 1;
  final int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChannelController>().loadChannels();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ChannelController>();
    final allChannels = controller.channels;

    return PageLayout(
      title: 'Daftar Channel Transfer',
      // Tombol Tambah di Pojok Kanan Bawah
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/tambah_channel');
        },
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : allChannels.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: allChannels.length,
                    itemBuilder: (context, index) {
                      final channel = allChannels[index];
                      return _buildChannelCard(channel);
                    },
                  ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.credit_card_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "Belum ada channel pembayaran",
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelCard(ChannelModel channel) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _fetchAndShowDetail(channel.id),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 1. Thumbnail Image / Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: channel.thumbnailUrl != null
                      ? Image.network(
                          channel.thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) =>
                              const Icon(Icons.broken_image, color: Colors.grey),
                        )
                      : Icon(_getIconByType(channel.type),
                          size: 30, color: Colors.blueAccent),
                ),
              ),
              const SizedBox(width: 16),

              // 2. Info Utama
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      channel.channelName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      channel.accountName,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    _buildStatusChip(channel.isActive),
                  ],
                ),
              ),

              // 3. Arrow Icon
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isActive ? Colors.green : Colors.red,
          width: 0.5,
        ),
      ),
      child: Text(
        isActive ? "Aktif" : "Non-Aktif",
        style: TextStyle(
          fontSize: 10,
          color: isActive ? Colors.green[700] : Colors.red[700],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  IconData _getIconByType(String type) {
    switch (type.toLowerCase()) {
      case 'bank':
      case 'bank_transfer':
        return Icons.account_balance;
      case 'ewallet':
      case 'e_wallet':
        return Icons.account_balance_wallet;
      case 'qris':
        return Icons.qr_code_2;
      default:
        return Icons.payment;
    }
  }

  // --- LOGIC DETAIL ---
  
  // Fungsi ini memanggil API Detail untuk mendapatkan data lengkap (No Rek, Catatan, QR Full)
  void _fetchAndShowDetail(int id) async {
    // Tampilkan loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Panggil Service secara langsung (atau lewat controller jika mau state management)
      final service = ChannelService(); // Instance sementara
      final detail = await service.getChannelDetail(id);
      
      if (!mounted) return;
      Navigator.pop(context); // Tutup loading

      _showDetailDialog(detail); // Tampilkan popup
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Tutup loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat detail: $e"), backgroundColor: Colors.red),
      );
    }
  }

  String _sanitizeUrl(String url) {
    if (url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }

  void _showDetailDialog(ChannelModel channel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75, // Naikkan sedikit agar muat
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Header dengan Thumbnail Besar
              Center(
                child: Column(
                  children: [
                    if (channel.thumbnailUrl != null)
                      Container(
                        height: 100, // Perbesar sedikit
                        width: 100,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _sanitizeUrl(channel.thumbnailUrl!), // 1. Paksa HTTPS
                            fit: BoxFit.cover,
                            // 2. Tambahkan Header Ngrok
                            headers: const {
                              "ngrok-skip-browser-warning": "true",
                              // Jika gambar butuh auth (private storage), tambahkan Authorization header disini
                            },
                            loadingBuilder: (ctx, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                            },
                            errorBuilder: (ctx, err, stack) {
                              // Debugging: Print error ke console jika masih gagal
                              print("Error loading thumbnail: $err"); 
                              return const Icon(Icons.broken_image, size: 40, color: Colors.grey);
                            },
                          ),
                        ),
                      ),
                    Text(
                      channel.channelName,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      channel.type.toUpperCase().replaceAll('_', ' '),
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              _detailRow("Nomor Rekening", channel.accountNumber, isCopyable: true),
              _detailRow("Atas Nama", channel.accountName),
              _detailRow("Catatan", channel.notes ?? '-'),

              const SizedBox(height: 24),

              // QR Code Section
              if (channel.qrCodeUrl != null) ...[
                const Text("QR Code Pembayaran", 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)
                    ]
                  ),
                  child: Column(
                    children: [
                      Image.network(
                        _sanitizeUrl(channel.qrCodeUrl!), // 1. Paksa HTTPS
                        fit: BoxFit.contain,
                        height: 250, // Beri tinggi pasti agar layout tidak loncat
                        // 2. Tambahkan Header Ngrok
                        headers: const {
                          "ngrok-skip-browser-warning": "true",
                        },
                        loadingBuilder: (ctx, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SizedBox(
                            height: 200,
                            child: Center(child: CircularProgressIndicator())
                          );
                        },
                        errorBuilder: (ctx, err, stack) {
                          print("Error loading QR: $err");
                          return const SizedBox(
                            height: 200,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                  Text("Gagal memuat QR Code"),
                                ],
                              ),
                            )
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Scan untuk membayar", 
                        style: TextStyle(color: Colors.grey[500], fontSize: 12)
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Tutup"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, {bool isCopyable = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
                if (isCopyable)
                  InkWell(
                    onTap: () {
                      // Implement copy to clipboard here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Disalin ke clipboard")),
                      );
                    },
                    child: const Icon(Icons.copy, size: 18, color: Colors.blue),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}