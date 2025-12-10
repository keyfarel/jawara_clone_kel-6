// lib/features/keluarga/presentation/pages/keluarga_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <-- HARUS DITAMBAHKAN
import 'package:myapp/layouts/pages_layout.dart';
import '../../controllers/keluarga_controller.dart';
import '../../data/models/keluarga_model.dart';
import '../../data/repository/keluarga_repository.dart';
import '../../data/services/keluarga_service.dart'; // Catatan: Sesuaikan nama file model dan service jika berbeda

// PERBAIKAN: Ganti StatefulWidget ke StatelessWidget jika menggunakan Provider
class ListKeluargaPage extends StatelessWidget {
  const ListKeluargaPage({super.key});

  // Fungsi _showFilterDialog dan _showDetail dipindahkan ke sini
  // agar dapat diakses oleh metode build.

  // === FILTER DIALOG ===
  void _showFilterDialog(BuildContext context, KeluargaController controller) {
    String? tempStatus = controller.selectedStatusFilter;
    final List<String> filterOptions = ["Semua", "Aktif", "Tidak Aktif"];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filter Keluarga"),
          content: DropdownButtonFormField<String>(
            value: tempStatus ?? 'Semua',
            items: filterOptions
                .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    ))
                .toList(),
            onChanged: (val) {
              tempStatus = val == 'Semua' ? null : val;
            },
            decoration: const InputDecoration(
              labelText: "Pilih Status",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.applyFilter(null);
                Navigator.pop(context);
              },
              child: const Text("Reset"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              onPressed: () {
                controller.applyFilter(tempStatus);
                Navigator.pop(context);
              },
              child: const Text("Terapkan"),
            ),
          ],
        );
      },
    );
  }

  // === DETAIL KELUARGA ===
  void _showDetail(BuildContext context, KeluargaModel keluarga) {
    final CitizenModel? kepalaKeluarga = keluarga.kepalaKeluarga;
    final List<CitizenModel> anggotaKeluarga = keluarga.citizens;
    
    final String kepalaKeluargaName = kepalaKeluarga?.name ?? '-';
    final String alamatRumah = keluarga.house.address;
    final String statusKepemilikan = keluarga.ownershipStatus;
    
    final isStatusActive = keluarga.status.toLowerCase() == 'active';
    final String statusDisplay = isStatusActive ? 'Aktif' : 'Tidak Aktif';
    final Color statusColor = isStatusActive ? Colors.green : Colors.redAccent;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            // Menyesuaikan padding untuk menghindari keyboard di Android/iOS
            bottom: MediaQuery.of(context).viewInsets.bottom + 16, 
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    height: 5,
                    width: 40,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Text(
                  "Detail Keluarga (${keluarga.id})", // Tampilkan ID keluarga
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Kepala Keluarga"),
                  subtitle: Text(kepalaKeluargaName),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Alamat Rumah"),
                  subtitle: Text(alamatRumah),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Status Kepemilikan"),
                  subtitle: Text(statusKepemilikan),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Status Keluarga"),
                  subtitle: Text(
                    statusDisplay,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("No. KK"),
                  subtitle: Text(keluarga.kkNumber ?? '-'),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Anggota Keluarga",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),

                if (anggotaKeluarga.isEmpty)
                  const Text(
                    "Belum ada data anggota keluarga.",
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  Column(
                    children: anggotaKeluarga
                        .map(
                          (a) => Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.person_outline),
                              title: Text(a.name),
                              subtitle: Text(a.familyRole),
                            ),
                          ),
                        )
                        .toList(),
                  ),

                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text("Tutup"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final service = KeluargaService();
        // PERHATIAN: Perbaiki import di repository/model/service jika terjadi error run time
        final repository = KeluargaRepository(service); 
        final controller = KeluargaController(repository);
        // Memuat data saat controller dibuat
        controller.fetchListKeluarga(); 
        return controller;
      },
      // Menggunakan Consumer untuk merebuild UI saat Controller berubah
      child: Consumer<KeluargaController>(
        builder: (context, controller, _) {
          return PageLayout(
            title: "Keluarga - Daftar",
            actions: [
              if (controller.state == KeluargaState.loaded)
                IconButton(
                  icon: const Icon(Icons.filter_alt),
                  onPressed: () => _showFilterDialog(context, controller), // <-- Melewatkan controller
                ),
              if (controller.state == KeluargaState.error)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: controller.fetchListKeluarga,
                ),
            ],
            body: Builder(
              builder: (context) {
                if (controller.state == KeluargaState.loading || controller.state == KeluargaState.initial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.state == KeluargaState.error) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 40),
                          const SizedBox(height: 8),
                          Text(
                            'Gagal memuat data:\n${controller.errorMessage ?? "Unknown Error"}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: controller.fetchListKeluarga,
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                // State Loaded
                final List<KeluargaModel> filteredList = controller.filteredList;
                final selectedStatus = controller.selectedStatusFilter; // Ambil status filter

                if (filteredList.isEmpty) {
                  return Center(
                    child: Text(selectedStatus != null && selectedStatus != 'Semua' 
                      ? "Tidak ada data keluarga dengan status '$selectedStatus' yang ditemukan."
                      : "Tidak ada data keluarga yang ditemukan."),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final keluarga = filteredList[index];
                    final kepalaKeluarga = keluarga.kepalaKeluarga;
                    final kepalaKeluargaName = kepalaKeluarga?.name ?? '-';
                    final alamatRumah = keluarga.house.address;
                    final statusKepemilikan = keluarga.ownershipStatus;
                    final isStatusActive = keluarga.status.toLowerCase() == 'active';
                    final statusColor = isStatusActive ? Colors.green : Colors.redAccent;
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: statusColor,
                          child: Text(
                            kepalaKeluargaName.isNotEmpty
                                ? kepalaKeluargaName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          kepalaKeluargaName,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text("Alamat: $alamatRumah\nStatus: $statusKepemilikan"),
                        isThreeLine: true,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          _showDetail(context, keluarga);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}