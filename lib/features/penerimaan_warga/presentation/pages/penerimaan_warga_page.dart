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
    // Load Data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PenerimaanWargaController>().loadVerificationList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch Controller
    final controller = context.watch<PenerimaanWargaController>();
    final List<PenerimaanWargaModel> allWarga = controller.listWarga;

    // Pagination Logic
    final totalPages = (allWarga.length / itemsPerPage).ceil();
    // Safety check currentPage
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Tombol Refresh & Filter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.blue),
                  onPressed: () => controller.loadVerificationList(),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement Filter Logic
                  },
                  icon: const Icon(Icons.filter_alt, color: Colors.white),
                  label: const Text("Filter"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // TABEL
            Container(
              width: double.infinity, // Agar lebar maksimal
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
              child: controller.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : controller.errorMessage != null
                      ? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(child: Text("Error: ${controller.errorMessage}")),
                        )
                      : displayedItems.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Center(child: Text("Tidak ada data pengajuan warga")),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
                                columns: const [
                                  DataColumn(label: Text('No', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Nama', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('NIK', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('L/P', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Foto', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold))),
                                ],
                                rows: List.generate(displayedItems.length, (index) {
                                  final item = displayedItems[index];
                                  final isVerified = item.statusRegistrasi == 'verified';

                                  return DataRow(
                                    cells: [
                                      DataCell(Text('${start + index + 1}')),
                                      DataCell(Text(item.nama)),
                                      DataCell(Text(item.nik)),
                                      DataCell(Text(item.email ?? '-')),
                                      DataCell(Text(item.jenisKelamin == 'male' ? 'L' : 'P')),
                                      
                                      // FOTO
                                      DataCell(
                                        item.fotoIdentitas != null
                                            ? InkWell(
                                                onTap: () => _showImageDialog(context, item.fotoIdentitas!),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(6),
                                                  child: Image.network(
                                                    item.fotoIdentitas!,
                                                    width: 40,
                                                    height: 40,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (_,__,___) => const Icon(Icons.broken_image, color: Colors.grey),
                                                  ),
                                                ),
                                              )
                                            : const Icon(Icons.person, color: Colors.grey),
                                      ),

                                      // STATUS
                                      DataCell(
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: isVerified ? Colors.green.shade100 : Colors.orange.shade100,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            item.statusRegistrasi?.toUpperCase() ?? 'PENDING',
                                            style: TextStyle(
                                              color: isVerified ? Colors.green.shade800 : Colors.orange.shade800,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12
                                            ),
                                          ),
                                        ),
                                      ),

                                      // AKSI
                                      DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.check_circle, color: Colors.green),
                                              tooltip: 'Terima',
                                              onPressed: () {
                                                _showConfirmDialog(context, item, true);
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.cancel, color: Colors.red),
                                              tooltip: 'Tolak',
                                              onPressed: () {
                                                _showConfirmDialog(context, item, false);
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

            // PAGINATION CONTROLS
            if (totalPages > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: currentPage > 1 ? () => setState(() => currentPage--) : null,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Text("Halaman $currentPage dari $totalPages", style: const TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: currentPage < totalPages ? () => setState(() => currentPage++) : null,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Dialog Lihat Foto Full
  void _showImageDialog(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(url, fit: BoxFit.contain),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup"),
            )
          ],
        ),
      ),
    );
  }

  // Dialog Konfirmasi Aksi
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
              // TODO: Panggil API Verify di Controller
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Aksi untuk ${item.nama} berhasil diproses")),
              );
            },
            child: Text(isAccept ? "Terima" : "Tolak", style: const TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}