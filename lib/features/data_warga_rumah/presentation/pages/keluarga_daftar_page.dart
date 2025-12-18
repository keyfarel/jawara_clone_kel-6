import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/layouts/pages_layout.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FamilyController>().loadFamilies();
    });
  }

  Future<void> _handleRefresh() async {
    await context.read<FamilyController>().loadFamilies(force: true);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FamilyController>();

    // Logic Filter
    final List<KeluargaModel> filteredList = selectedStatus == null
        ? controller.families
        : controller.families
              .where(
                (k) => k.status.toLowerCase() == selectedStatus!.toLowerCase(),
              )
              .toList();

    return PageLayout(
      title: "Daftar Keluarga",
      actions: [
        IconButton(icon: const Icon(Icons.refresh), onPressed: _handleRefresh),
        IconButton(
          icon: const Icon(Icons.filter_alt),
          onPressed: () => _showFilterDialog(context),
        ),
      ],
      // Gunakan RefreshIndicator di root body agar bisa ditarik kapan saja
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: Colors.blue,
        child: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : filteredList.isEmpty
            ? _buildEmptyState() // <--- TAMPILKAN INI JIKA KOSONG
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredList.length,
                // Tambahkan physics agar selalu bisa discroll (penting utk refresh)
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final keluarga = filteredList[index];
                  return _buildCard(keluarga);
                },
              ),
      ),
    );
  }

  // --- WIDGET BARU: TAMPILAN KOSONG ---
  Widget _buildEmptyState() {
    // Gunakan ListView agar tetap bisa di-refresh (pull-to-refresh butuh scrollable)
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
        ), // Jarak dari atas
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.group_off_rounded, // Icon "Tidak ada grup/orang"
                  size: 60,
                  color: Colors.blue.shade300,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Belum Ada Data Keluarga",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Silakan tambah data keluarga baru melalui tombol tambah di menu utama.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: _handleRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text("Coba Muat Ulang"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ... (Sisa kode _buildCard, _showDetail, _infoRow, _showFilterDialog TETAP SAMA) ...

  // Widget Card Keluarga
  Widget _buildCard(KeluargaModel keluarga) {
    // 1. LOGIC WARNA STATUS
    Color statusColor;
    String statusLabel;

    switch (keluarga.status) {
      case 'active':
        statusColor = Colors.green;
        statusLabel = "Aktif";
        break;
      case 'moved':
        statusColor = Colors.orange;
        statusLabel = "Pindah (Non-Aktif)";
        break;
      case 'inactive':
        statusColor = Colors.grey;
        statusLabel = "Tidak Aktif";
        break;
      default:
        statusColor = Colors.grey;
        statusLabel = keluarga.status;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor,
          foregroundColor: Colors.white,
          child: Text(keluarga.namaKepalaKeluarga.isNotEmpty ? keluarga.namaKepalaKeluarga[0] : '?'),
        ),
        title: Text(keluarga.namaKepalaKeluarga, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Alamat: ${keluarga.alamatRumah}"),
            // 2. TAMPILKAN LABEL STATUS YANG JELAS
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: statusColor.withOpacity(0.5))
              ),
              child: Text(
                statusLabel, 
                style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)
              ),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          _showDetail(context, keluarga);
        },
      ),
    );
  }

  void _showDetail(BuildContext context, KeluargaModel keluarga) {
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
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
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
                  "Keluarga ${keluarga.namaKepalaKeluarga}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                _infoRow("No KK", keluarga.kkNumber),
                _infoRow("Alamat", keluarga.alamatRumah),
                _infoRow("Status Rumah", keluarga.ownershipStatus),
                const SizedBox(height: 16),
                const Text(
                  "Anggota Keluarga",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                keluarga.citizens.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            "Belum ada data anggota keluarga.",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
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
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.person,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  member['name'] ?? 'Tanpa Nama',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(member['family_role'] ?? '-'),
                                trailing: Text(
                                  member['status'] == 'active'
                                      ? 'Aktif'
                                      : 'Non-Aktif',
                                  style: TextStyle(
                                    color: member['status'] == 'active'
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 12,
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
            ),
          ],
        );
      },
    );
  }
}
