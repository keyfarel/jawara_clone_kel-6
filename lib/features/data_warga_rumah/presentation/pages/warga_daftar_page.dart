import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../layouts/pages_layout.dart';
import '../../controllers/citizen_controller.dart';
import '../../data/models/citizen_model.dart';

class WargaDaftarPage extends StatefulWidget {
  const WargaDaftarPage({super.key});

  @override
  State<WargaDaftarPage> createState() => _WargaDaftarPageState();
}

class _WargaDaftarPageState extends State<WargaDaftarPage> {
  String searchQuery = '';
  
  // ⚠️ PENTING: Ganti URL ini jika Ngrok restart / berubah
  final String baseImageUrl = "https://unmoaning-lenora-photomechanically.ngrok-free.dev/storage/";

  @override
  void initState() {
    super.initState();
    // Panggil data saat halaman pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // force: false -> Gunakan Cache jika ada (agar tidak loading terus)
      context.read<CitizenController>().loadCitizens(force: false);
    });
  }

  // Fungsi Refresh (Tarik ke bawah)
  Future<void> _handleRefresh() async {
    // force: true -> Paksa ambil data baru dari Server
    await context.read<CitizenController>().loadCitizens(force: true);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CitizenController>();
    final allCitizens = controller.citizens;

    // Logic Filter Pencarian Lokal
    final filteredList = allCitizens.where((citizen) {
      final query = searchQuery.toLowerCase();
      return citizen.name.toLowerCase().contains(query) ||
          citizen.nik.contains(query);
    }).toList();

    return PageLayout(
      title: 'Daftar Warga',
      actions: [
        // Tombol Refresh Manual
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => controller.loadCitizens(force: true),
        )
      ],
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari Nama atau NIK...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (val) {
                setState(() {
                  searchQuery = val;
                });
              },
            ),
          ),

          // 2. List Data dengan RefreshIndicator
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : controller.errorMessage != null
                      // Tampilan Error
                      ? ListView(
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                                  const SizedBox(height: 10),
                                  Text("Gagal memuat data:\n${controller.errorMessage}", textAlign: TextAlign.center),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: _handleRefresh,
                                    child: const Text("Coba Lagi"),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      : filteredList.isEmpty
                          // Tampilan Kosong
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                                Center(
                                  child: Column(
                                    children: [
                                      const Icon(Icons.search_off, size: 48, color: Colors.grey),
                                      const SizedBox(height: 10),
                                      Text(searchQuery.isEmpty ? "Belum ada data warga" : "Warga tidak ditemukan", 
                                        style: const TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          // Tampilan List Data
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                final warga = filteredList[index];
                                return _buildWargaCard(warga);
                              },
                            ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Card Item List
  Widget _buildWargaCard(CitizenModel warga) {
    final bool isActive = warga.status == 'active' || warga.status == 'permanent';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showDetailDialog(warga),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar / Foto Profil
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.blue.shade100,
                backgroundImage: (warga.idCardPhoto != null) 
                    ? NetworkImage("$baseImageUrl${warga.idCardPhoto}") 
                    : null,
                child: (warga.idCardPhoto == null) 
                    ? Text(
                        warga.name.isNotEmpty ? warga.name[0].toUpperCase() : '?', 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue)
                      ) 
                    : null,
              ),
              const SizedBox(width: 16),
              
              // Info Utama
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      warga.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${warga.familyRole} • ${warga.occupation ?? 'Belum Bekerja'}",
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      warga.address ?? 'Alamat tidak tersedia',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Status Chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isActive ? Colors.green : Colors.red, 
                    width: 0.5
                  ),
                ),
                child: Text(
                  warga.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog Detail Warga
  void _showDetailDialog(CitizenModel warga) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.person_pin, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(child: Text(warga.name, overflow: TextOverflow.ellipsis)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow("NIK", warga.nik),
              _detailRow("No. HP", warga.phone),
              _detailRow("Gender", warga.gender == 'male' ? "Laki-laki" : "Perempuan"),
              _detailRow("Peran", warga.familyRole),
              
              const Divider(),
              _detailRow("Pendidikan", warga.education ?? '-'),
              _detailRow("Pekerjaan", warga.occupation ?? '-'),
              const Divider(),

              _detailRow("Tempat Lahir", warga.birthPlace ?? '-'),
              _detailRow("Tanggal Lahir", warga.birthDate ?? '-'),
              _detailRow("Agama", warga.religion ?? '-'),
              _detailRow("Gol. Darah", warga.bloodType ?? '-'),
              
              const SizedBox(height: 10),
              const Text("Alamat Rumah:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              Text(warga.address ?? '-', style: const TextStyle(fontSize: 14)),
              
              const SizedBox(height: 12),
              const Text("Foto KTP:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 8),
              
              // Tampilan Foto KTP
              if (warga.idCardPhoto != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    "$baseImageUrl${warga.idCardPhoto}",
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 150,
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (ctx, err, stack) => Container(
                      height: 100, 
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image, color: Colors.grey),
                          Text("Gagal memuat foto", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      )
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: const Text("- Tidak ada foto KTP -", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey), textAlign: TextAlign.center),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  // Helper Widget untuk Baris Detail
  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text("$label:", style: const TextStyle(color: Colors.grey, fontSize: 13))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}