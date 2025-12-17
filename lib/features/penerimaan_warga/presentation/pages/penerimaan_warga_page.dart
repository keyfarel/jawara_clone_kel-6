import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/layouts/pages_layout.dart';
import '../../controllers/penerimaan_warga_controller.dart';
import '../../data/models/penerimaan_warga_model.dart';
import 'penerimaan_warga_detail_page.dart';

class PenerimaanWargaPage extends StatefulWidget {
  const PenerimaanWargaPage({super.key});

  @override
  State<PenerimaanWargaPage> createState() => _PenerimaanWargaPageState();
}

class _PenerimaanWargaPageState extends State<PenerimaanWargaPage> {
  // Pagination State
  int currentPage = 1;
  final int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PenerimaanWargaController>().loadVerificationList(force: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PenerimaanWargaController>();
    final List<PenerimaanWargaModel> allWarga = controller.listWarga;

    // --- Pagination Logic (Safe Version) ---
    final int totalItems = allWarga.length;
    final int totalPages = (totalItems / itemsPerPage).ceil();

    // Reset current page jika out of bounds
    if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
    if (totalPages == 0) currentPage = 1;

    // Hitung range items
    final int startIndex = (currentPage - 1) * itemsPerPage;
    final int endIndex = (startIndex + itemsPerPage < totalItems)
        ? startIndex + itemsPerPage
        : totalItems;

    // Ambil data untuk halaman ini
    final List<PenerimaanWargaModel> displayedItems = 
        (allWarga.isNotEmpty && startIndex < totalItems)
            ? allWarga.sublist(startIndex, endIndex)
            : [];

    return PageLayout(
      title: 'Verifikasi Warga',
      body: RefreshIndicator(
        onRefresh: () => controller.loadVerificationList(force: true),
        child: Column(
          children: [
            // --- HEADER INFO & FILTER ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Menunggu Verifikasi (${allWarga.length})",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  // Filter Button (Opsional)
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Filter status belum tersedia")),
                      );
                    },
                    icon: const Icon(Icons.filter_list, size: 18),
                    label: const Text("Filter"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),

            // --- CONTENT LIST ---
            Expanded(
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : controller.errorMessage != null
                      // Tampilan Error
                      ? ListView(
                          children: [
                            const SizedBox(height: 100),
                            Center(
                              child: Column(
                                children: [
                                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                                  const SizedBox(height: 16),
                                  Text("Gagal: ${controller.errorMessage}"),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () => controller.loadVerificationList(),
                                    child: const Text("Coba Lagi"),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      : displayedItems.isEmpty
                          // Tampilan Kosong
                          ? ListView(
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_circle_outline, size: 80, color: Colors.green.shade100),
                                      const SizedBox(height: 16),
                                      const Text(
                                        "Semua beres!",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "Tidak ada pengajuan warga baru.",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          // Tampilan List Data
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              itemCount: displayedItems.length,
                              itemBuilder: (context, index) {
                                final warga = displayedItems[index];
                                return _buildCardItem(context, warga);
                              },
                            ),
            ),

            // --- PAGINATION CONTROLS ---
            if (totalPages > 1)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade200, blurRadius: 4, offset: const Offset(0, -2))
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: currentPage > 1
                          ? () => setState(() => currentPage--)
                          : null,
                    ),
                    Text(
                      "Halaman $currentPage dari $totalPages",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: currentPage < totalPages
                          ? () => setState(() => currentPage++)
                          : null,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- Widget Item List ---
  Widget _buildCardItem(BuildContext context, PenerimaanWargaModel warga) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigasi ke Detail
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PenerimaanWargaDetailPage(warga: warga),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Avatar Inisial
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blue.shade50,
                child: Text(
                  warga.nama.isNotEmpty ? warga.nama[0].toUpperCase() : '?',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              const SizedBox(width: 16),
              
              // Info Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      warga.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "NIK: ${warga.nik}",
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Peran: ${warga.peranKeluarga}", // Tampilkan peran
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}