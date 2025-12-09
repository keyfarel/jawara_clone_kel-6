import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../layouts/pages_layout.dart';
import '../../controllers/penerimaan_warga_controller.dart';
import '../../data/models/penerimaan_warga_model.dart';

class PenerimaanWargaPage extends StatefulWidget {
  const PenerimaanWargaPage({super.key});

  @override
  State<PenerimaanWargaPage> createState() => _PenerimaanWargaPageState();
}

class _PenerimaanWargaPageState extends State<PenerimaanWargaPage> {
  int currentPage = 1;
  final int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PenerimaanWargaController>().loadVerificationList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PenerimaanWargaController>();
    final List<PenerimaanWargaModel> allWarga = controller.listWarga;

    // --- Pagination Logic ---
    final totalPages = (allWarga.length / itemsPerPage).ceil();
    if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
    if (totalPages == 0) currentPage = 1;

    final start = (currentPage - 1) * itemsPerPage;
    final end = (start + itemsPerPage < allWarga.length)
        ? start + itemsPerPage
        : allWarga.length;
    
    final displayedItems = allWarga.isNotEmpty 
        ? allWarga.sublist(start, end) 
        : [];

    return PageLayout(
      title: 'Penerimaan Warga',
      body: RefreshIndicator(
        onRefresh: () => controller.loadVerificationList(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // --- Header Toolbar (Filter) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total: ${allWarga.length} Pengajuan",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement Filter Logic
                    },
                    icon: const Icon(Icons.filter_list, size: 18, color: Colors.white),
                    label: const Text("Filter"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- Content List ---
              if (controller.isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (controller.errorMessage != null)
                Center(child: Text("Error: ${controller.errorMessage}"))
              else if (displayedItems.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.inbox, size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("Tidak ada pengajuan warga", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayedItems.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = displayedItems[index];
                    return _buildMobileCard(context, item);
                  },
                ),

              const SizedBox(height: 24),

              // --- Pagination Controls ---
              if (totalPages > 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: currentPage > 1 ? () => setState(() => currentPage--) : null,
                      icon: const Icon(Icons.chevron_left),
                      style: IconButton.styleFrom(backgroundColor: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "Halaman $currentPage / $totalPages",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      onPressed: currentPage < totalPages ? () => setState(() => currentPage++) : null,
                      icon: const Icon(Icons.chevron_right),
                      style: IconButton.styleFrom(backgroundColor: Colors.white),
                    ),
                  ],
                ),
                
              const SizedBox(height: 40), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET: Mobile Card Layout ---
  Widget _buildMobileCard(BuildContext context, PenerimaanWargaModel item) {
    final isVerified = item.statusRegistrasi == 'verified';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. Header Card (Foto & Info Utama)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto Profil
                GestureDetector(
                  onTap: item.fotoIdentitas != null 
                      ? () => _showImageDialog(context, item.fotoIdentitas!) 
                      : null,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      image: item.fotoIdentitas != null
                          ? DecorationImage(
                              image: NetworkImage(item.fotoIdentitas!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: item.fotoIdentitas == null
                        ? Icon(Icons.person, color: Colors.grey.shade400, size: 30)
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Nama & NIK
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.nama,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "NIK: ${item.nik}",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Status Chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isVerified ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.statusRegistrasi?.toUpperCase() ?? 'PENDING',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isVerified ? Colors.green : Colors.orange[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // 2. Detail Info Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildInfoItem(Icons.wc, item.jenisKelamin == 'male' ? 'Laki-laki' : 'Perempuan'),
                _buildInfoItem(Icons.group, item.peranKeluarga),
              ],
            ),
          ),
          
          if(item.email != null)
             Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                     const Icon(Icons.email_outlined, size: 16, color: Colors.grey),
                     const SizedBox(width: 8),
                     Expanded(
                       child: Text(item.email!, 
                         style: const TextStyle(fontSize: 13, color: Colors.black54),
                         overflow: TextOverflow.ellipsis,
                       ),
                     )
                  ],
                ),
             ),

          // 3. Action Buttons (Full Width)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                // Tombol Tolak
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showConfirmDialog(context, item, false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Tolak"),
                  ),
                ),
                const SizedBox(width: 12),
                // Tombol Terima
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showConfirmDialog(context, item, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    child: const Text("Terima"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget untuk Info Kecil
  Widget _buildInfoItem(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // --- Dialog Helpers Tetap Sama ---
  void _showImageDialog(BuildContext context, String? url) {
    // 1. Cek Jika URL Null atau Kosong sebelum membuka dialog
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tidak ada foto identitas yang lampirkan"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent, // Background transparan agar fokus ke foto
        insetPadding: const EdgeInsets.all(10), // Memberi sedikit jarak dari tepi layar
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Container Gambar
            InteractiveViewer( // Fitur Zoom In/Out
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                  
                  // 2. Handling saat Loading
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text("Memuat Foto...", style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    );
                  },

                  // 3. Handling Exception (Error / Gambar Rusak)
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 250,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.broken_image_rounded, size: 60, color: Colors.grey),
                          SizedBox(height: 12),
                          Text(
                            "Gagal Memuat Foto",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "File gambar rusak atau tidak ditemukan di server.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // Tombol Tutup (X) di Pojok Kanan Atas
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context, PenerimaanWargaModel item, bool isAccept) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isAccept ? "Terima Warga?" : "Tolak Warga?"),
        content: Text("Anda yakin ingin ${isAccept ? 'menerima' : 'menolak'} pengajuan dari ${item.nama}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: isAccept ? Colors.green : Colors.red),
            onPressed: () {
              // TODO: Implement API Call via Controller
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Aksi untuk ${item.nama} sedang diproses...")),
              );
            },
            child: Text(isAccept ? "Ya, Terima" : "Ya, Tolak", style: const TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}