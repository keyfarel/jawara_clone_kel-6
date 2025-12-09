import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../layouts/pages_layout.dart';
import '../../controllers/rumah_controller.dart';
import '../../data/models/rumah_model.dart';

class RumahDaftarPage extends StatefulWidget {
  const RumahDaftarPage({super.key});

  @override
  State<RumahDaftarPage> createState() => _RumahDaftarPageState();
}

class _RumahDaftarPageState extends State<RumahDaftarPage> {
  // Filter States
  String? selectedStatus;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load Data saat Init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RumahController>().loadHouses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RumahController>();
    final allHouses = controller.houses;

    // Logic Filtering Client Side
    List<RumahModel> filteredList = allHouses.where((rumah) {
      // 1. Filter Status
      bool matchStatus = true;
      if (selectedStatus != null) {
        matchStatus = rumah.statusDisplay == selectedStatus;
      }

      // 2. Filter Search (Nama / Alamat)
      bool matchSearch = true;
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        matchSearch = rumah.houseName.toLowerCase().contains(query) ||
            rumah.address.toLowerCase().contains(query);
      }

      return matchStatus && matchSearch;
    }).toList();

    return PageLayout(
      title: "Rumah - Daftar",
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_alt),
          onPressed: () {
            _showFilterDialog(context);
          },
        ),
      ],
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.errorMessage != null
              ? Center(child: Text("Error: ${controller.errorMessage}"))
              : filteredList.isEmpty
                  ? const Center(child: Text("Tidak ada data rumah"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final rumah = filteredList[index];
                        final isOccupied = rumah.status == 'occupied';

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isOccupied
                                  ? Colors.blueAccent
                                  : Colors.green,
                              child: Text(
                                "${index + 1}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              rumah.houseName,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(rumah.address, style: const TextStyle(fontSize: 12)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isOccupied ? Colors.blue[50] : Colors.green[50],
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: isOccupied ? Colors.blue : Colors.green, width: 0.5)
                                  ),
                                  child: Text(
                                    rumah.statusDisplay,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isOccupied ? Colors.blue : Colors.green,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              _showDetail(context, rumah);
                            },
                          ),
                        );
                      },
                    ),
    );
  }

  // === FILTER DIALOG ===
  void _showFilterDialog(BuildContext context) {
    String tempSearch = searchQuery;
    String? tempStatus = selectedStatus;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filter Rumah"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔍 Input Alamat
                TextField(
                  controller: TextEditingController(text: searchQuery),
                  decoration: const InputDecoration(
                    labelText: "Cari (Nama/Alamat)",
                    hintText: "Contoh: Blok A...",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (val) {
                    tempSearch = val;
                  },
                ),
                const SizedBox(height: 16),

                // 🏠 Dropdown Status
                DropdownButtonFormField<String>(
                  value: tempStatus,
                  items: ["Tersedia", "Ditempati"]
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (val) {
                    tempStatus = val;
                  },
                  decoration: const InputDecoration(
                    labelText: "Pilih Status",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            // 🔁 Reset Filter
            TextButton(
              onPressed: () {
                setState(() {
                  selectedStatus = null;
                  searchQuery = '';
                });
                Navigator.pop(context);
              },
              child: const Text("Reset Filter"),
            ),

            // ✅ Terapkan Filter
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              onPressed: () {
                setState(() {
                  selectedStatus = tempStatus;
                  searchQuery = tempSearch;
                });
                Navigator.pop(context);
              },
              child: const Text("Terapkan"),
            ),
          ],
        );
      },
    );
  }

  // === DETAIL RUMAH ===
  void _showDetail(BuildContext context, RumahModel rumah) {
    // Note: Untuk Riwayat Penghuni, idealnya ada endpoint detail khusus /houses/{id}
    // yang mengembalikan history. Sementara kita kosongkan atau ambil dari data yg ada.
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
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
                  "Detail Rumah",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),

                _buildDetailRow("Nama Rumah", rumah.houseName),
                _buildDetailRow("Alamat", rumah.address),
                _buildDetailRow("Tipe Rumah", rumah.houseType),
                _buildDetailRow("Pemilik", rumah.ownerName),
                
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text("Fasilitas Lengkap:", style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 8),
                    Icon(
                      rumah.hasCompleteFacilities ? Icons.check_circle : Icons.cancel,
                      color: rumah.hasCompleteFacilities ? Colors.green : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(rumah.hasCompleteFacilities ? "Ya" : "Tidak"),
                  ],
                ),

                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Status Saat Ini"),
                  subtitle: Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: rumah.status == 'occupied' ? Colors.blue[100] : Colors.green[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      rumah.statusDisplay,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: rumah.status == 'occupied' ? Colors.blue[800] : Colors.green[800],
                      ),
                    ),
                  ),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$label:",
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}