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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CitizenController>().loadCitizens();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CitizenController>();
    final allCitizens = controller.citizens;

    // Filter Logic
    final filteredList = allCitizens.where((citizen) {
      final query = searchQuery.toLowerCase();
      return citizen.name.toLowerCase().contains(query) ||
          citizen.nik.contains(query);
    }).toList();

    return PageLayout(
      title: 'Daftar Warga',
      // Search Bar di AppBar (Opsional, atau di body)
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => controller.loadCitizens(),
        )
      ],
      body: Column(
        children: [
          // Search Field
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
              ),
              onChanged: (val) {
                setState(() {
                  searchQuery = val;
                });
              },
            ),
          ),

          // List Data
          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.errorMessage != null
                    ? Center(child: Text("Error: ${controller.errorMessage}"))
                    : filteredList.isEmpty
                        ? const Center(child: Text("Data warga tidak ditemukan"))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final warga = filteredList[index];
                              return _buildWargaCard(warga);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildWargaCard(CitizenModel warga) {
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
              // Avatar
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.blue.shade100,
                backgroundImage: (warga.idCardPhoto != null) 
                    ? NetworkImage("https://unmoaning-lenora-photomechanically.ngrok-free.dev/storage/${warga.idCardPhoto}") 
                    : null, // Jika ada foto KTP, tampilkan (perlu URL lengkap)
                child: (warga.idCardPhoto == null) 
                    ? Text(warga.name[0].toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)) 
                    : null,
              ),
              const SizedBox(width: 16),
              
              // Info
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
                      "${warga.familyRole} • ${warga.houseName}",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      warga.address ?? '-',
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
                  color: warga.status == 'permanent' ? Colors.green.shade50 : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: warga.status == 'permanent' ? Colors.green : Colors.orange, 
                    width: 0.5
                  ),
                ),
                child: Text(
                  warga.status == 'permanent' ? 'Tetap' : 'Pindah',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: warga.status == 'permanent' ? Colors.green : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
              _detailRow("Tempat Lahir", warga.birthPlace ?? '-'),
              _detailRow("Tanggal Lahir", warga.birthDate ?? '-'),
              _detailRow("Agama", warga.religion ?? '-'),
              _detailRow("Gol. Darah", warga.bloodType ?? '-'),
              const Divider(),
              const Text("Alamat Rumah:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(warga.address ?? '-', style: const TextStyle(fontSize: 14)),
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

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text("$label:", style: const TextStyle(color: Colors.grey, fontSize: 13))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}