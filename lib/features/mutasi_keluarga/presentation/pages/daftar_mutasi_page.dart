import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../layouts/pages_layout.dart';
import '../../controllers/mutasi_controller.dart';
import '../../data/models/mutasi_model.dart';

class DaftarMutasiPage extends StatefulWidget {
  const DaftarMutasiPage({super.key});

  @override
  State<DaftarMutasiPage> createState() => _DaftarMutasiPageState();
}

class _DaftarMutasiPageState extends State<DaftarMutasiPage> {
  // ======= FILTER STATE =======
  String? selectedStatus;
  // String? selectedKeluarga; // Opsional jika ingin filter keluarga

  @override
  void initState() {
    super.initState();
    // Load data saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MutasiController>().loadMutations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MutasiController>();
    
    // Logic Filter Client Side
    List<MutasiModel> displayedList = controller.mutations;
    if (selectedStatus != null) {
      displayedList = displayedList
          .where((item) => item.jenisMutasi == selectedStatus)
          .toList();
    }

    return PageLayout(
      title: "Mutasi Keluarga - Daftar",
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Tombol filter & Refresh
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 // Tombol Refresh Kecil
                 IconButton(
                   icon: const Icon(Icons.refresh, color: Colors.blue),
                   onPressed: () => controller.loadMutations(),
                 ),
                 ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  label: const Text(
                    "Filter",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => _showFilterDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Konten Utama
            Expanded(
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : controller.errorMessage != null
                      ? Center(child: Text("Error: ${controller.errorMessage}"))
                      : displayedList.isEmpty
                          ? const Center(child: Text("Tidak ada data mutasi"))
                          : RefreshIndicator(
                              onRefresh: controller.loadMutations,
                              child: ListView.builder(
                                itemCount: displayedList.length,
                                itemBuilder: (context, index) {
                                  final item = displayedList[index];
                                  return GestureDetector(
                                    onTap: () => _showDetail(context, item),
                                    child: Card(
                                      elevation: 2,
                                      margin: const EdgeInsets.only(bottom: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14, horizontal: 16),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // No (Index + 1)
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                "${index + 1}",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                            // Tanggal
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                item.formattedDate,
                                                style: const TextStyle(
                                                    color: Colors.black87),
                                              ),
                                            ),
                                            // Nama Keluarga
                                            Expanded(
                                              flex: 4,
                                              child: Text(
                                                item.keluarga,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                            // Badge Jenis Mutasi
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 6, horizontal: 8),
                                                decoration: BoxDecoration(
                                                  color: Colors.green[100],
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  item.jenisMutasi,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                  ),
                                                ),
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
            ),
          ],
        ),
      ),
    );
  }

  // ========================
  // DETAIL BOTTOM SHEET
  // ========================
  void _showDetail(BuildContext context, MutasiModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const Text(
                "Detail Mutasi Keluarga",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              _detailItem("Keluarga", item.keluarga),
              _detailItem("Alamat Lama", item.alamatLama),
              _detailItem("Alamat Baru", item.alamatBaru),
              _detailItem("Tanggal Mutasi", item.formattedDate),
              _detailItem("Jenis Mutasi", item.jenisMutasi),
              _detailItem("Alasan", item.alasan),
              _detailItem("Status", item.status),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.close),
                  label: const Text("Tutup"),
                  onPressed: () => Navigator.pop(context),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.w500)),
          Text(value,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
        ],
      ),
    );
  }

  // ========================
  // FILTER DIALOG
  // ========================
  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Filter Mutasi"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: "Jenis Mutasi",
                  border: OutlineInputBorder(),
                ),
                // Sesuaikan opsi ini dengan data di Backend
                items: ["Pindah Rumah", "Keluar Perumahan", "Datang Baru"]
                    .map((status) =>
                        DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (val) => setState(() => selectedStatus = val),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedStatus = null;
                });
                Navigator.pop(context);
              },
              child: const Text("Reset"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
              ),
              child: const Text("Terapkan"),
            ),
          ],
        );
      },
    );
  }
}