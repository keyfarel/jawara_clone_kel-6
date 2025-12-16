import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../layouts/pages_layout.dart';
import '../../controllers/family_controller.dart';
import '../../data/models/keluarga_model.dart';

class KeluargaDaftarPage extends StatefulWidget {
  const KeluargaDaftarPage({super.key});

  @override
  State<KeluargaDaftarPage> createState() => _KeluargaDaftarPageState();
}

class _KeluargaDaftarPageState extends State<KeluargaDaftarPage> {
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    // Load data saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FamilyController>().loadFamilies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FamilyController>();
    
    // Logic Filter
    final List<KeluargaModel> filteredList = selectedStatus == null
        ? controller.families
        : controller.families
            .where((k) => k.status.toLowerCase() == selectedStatus!.toLowerCase())
            .toList();

    return PageLayout(
      title: "Daftar Keluarga",
      actions: [
         IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => controller.loadFamilies(),
        ),
        IconButton(
          icon: const Icon(Icons.filter_alt),
          onPressed: () => _showFilterDialog(context),
        ),
      ],
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final keluarga = filteredList[index];
                return _buildCard(keluarga);
              },
            ),
    );
  }

  // Widget Card Keluarga
  Widget _buildCard(KeluargaModel keluarga) {
     Color statusColor = keluarga.status == 'active' ? Colors.green : Colors.grey;

     return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor,
          child: Text(keluarga.namaKepalaKeluarga.isNotEmpty ? keluarga.namaKepalaKeluarga[0] : '?'),
        ),
        title: Text(keluarga.namaKepalaKeluarga, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Alamat: ${keluarga.alamatRumah}\nStatus: ${keluarga.status}"),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          _showDetail(context, keluarga); // <--- Klik ini memanggil detail
        },
      ),
    );
  }

  // === PERBAIKAN UTAMA ADA DI SINI ===
  void _showDetail(BuildContext context, KeluargaModel keluarga) {
    // Kita tidak membuat list manual lagi.
    // Kita langsung pakai data dari 'keluarga.citizens'

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          // Batasi tinggi agar tidak fullscreen
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Garis Indikator
                Center(
                  child: Container(
                    height: 5, width: 40,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300], borderRadius: BorderRadius.circular(4)
                    ),
                  ),
                ),
                
                // Header Detail
                Text("Keluarga ${keluarga.namaKepalaKeluarga}", 
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                ),
                const Divider(),
                
                // Info Umum
                _infoRow("No KK", keluarga.kkNumber),
                _infoRow("Alamat", keluarga.alamatRumah),
                _infoRow("Status Rumah", keluarga.ownershipStatus),
                
                const SizedBox(height: 16),
                const Text("Anggota Keluarga", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),

                // List Anggota (Dynamic)
                keluarga.citizens.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: Text("Belum ada data anggota keluarga.", style: TextStyle(color: Colors.grey))),
                      )
                    : Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: keluarga.citizens.length,
                          itemBuilder: (ctx, idx) {
                            final member = keluarga.citizens[idx];
                            return Card(
                              elevation: 0,
                              color: Colors.grey.shade50,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(8)
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.person, color: Colors.blue),
                                title: Text(member['name'] ?? 'Tanpa Nama', style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(member['family_role'] ?? '-'),
                                trailing: Text(
                                  member['status'] == 'active' ? 'Aktif' : 'Non-Aktif',
                                  style: TextStyle(
                                    color: member['status'] == 'active' ? Colors.green : Colors.red,
                                    fontSize: 12
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Tutup"),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper Widget kecil
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    String? tempStatus = selectedStatus;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filter Status"),
          content: DropdownButtonFormField<String>(
            value: tempStatus,
            items: const [
              DropdownMenuItem(value: "active", child: Text("Aktif")),
              DropdownMenuItem(value: "moved", child: Text("Pindah")),
              DropdownMenuItem(value: "inactive", child: Text("Tidak Aktif")),
            ],
            onChanged: (val) => tempStatus = val,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() => selectedStatus = null);
                Navigator.pop(context);
              },
              child: const Text("Reset"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => selectedStatus = tempStatus);
                Navigator.pop(context);
              },
              child: const Text("Terapkan"),
            )
          ],
        );
      },
    );
  }
}