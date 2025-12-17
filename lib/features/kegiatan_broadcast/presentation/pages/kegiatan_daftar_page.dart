import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/layouts/pages_layout.dart';
import '../../controllers/kegiatan_controller.dart';
import '../../data/models/kegiatan_model.dart';

class KegiatanDaftarPage extends StatefulWidget {
  const KegiatanDaftarPage({super.key});

  @override
  State<KegiatanDaftarPage> createState() => _KegiatanDaftarPageState();
}

class _KegiatanDaftarPageState extends State<KegiatanDaftarPage> {
  String searchQuery = '';
  String? filterStatus; // null = semua, upcoming, completed, etc

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KegiatanController>().loadActivities();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<KegiatanController>();
    final allActivities = controller.activities;

    // Filter Logic
    final filteredList = allActivities.where((kegiatan) {
      // 1. Filter Search
      final matchesSearch = kegiatan.name.toLowerCase().contains(searchQuery.toLowerCase());
      
      // 2. Filter Status (Dropdown)
      final matchesStatus = filterStatus == null || kegiatan.status == filterStatus;

      return matchesSearch && matchesStatus;
    }).toList();

    return PageLayout(
      title: 'Daftar Kegiatan',
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => controller.loadActivities(),
        ),
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: _showFilterDialog,
        ),
      ],
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari nama kegiatan...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (val) {
                setState(() {
                  searchQuery = val;
                });
              },
            ),
          ),

          // List
          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.errorMessage != null
                    ? Center(child: Text("Error: ${controller.errorMessage}"))
                    : filteredList.isEmpty
                        ? const Center(child: Text("Tidak ada kegiatan"))
                        : ListView.builder(
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final kegiatan = filteredList[index];
                              return _buildCard(kegiatan);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(KegiatanModel kegiatan) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showDetailKegiatan(kegiatan),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icon Kategori
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getCategoryIcon(kegiatan.category),
                  color: Colors.blue[700],
                ),
              ),
              const SizedBox(width: 16),
              
              // Detail
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kegiatan.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(kegiatan.formattedDate, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        const SizedBox(width: 12),
                        Icon(Icons.location_on, size: 12, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            kegiatan.location, 
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Badge Status
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(kegiatan.status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  kegiatan.statusDisplay,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helpers ---

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'olahraga': return Icons.sports_soccer;
      case 'social': return Icons.people;
      case 'keagamaan': return Icons.mosque; // atau church
      case 'kebersihan': return Icons.cleaning_services;
      default: return Icons.event;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'upcoming': return Colors.orange;
      case 'ongoing': return Colors.green;
      case 'completed': return Colors.blue;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  // --- Dialogs ---

  void _showDetailKegiatan(KegiatanModel kegiatan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(kegiatan.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow(Icons.calendar_today, 'Tanggal: ${kegiatan.formattedDate}'),
            _detailRow(Icons.location_on, 'Lokasi: ${kegiatan.location}'),
            _detailRow(Icons.person, 'PJ: ${kegiatan.personInCharge}'),
            _detailRow(Icons.category, 'Kategori: ${kegiatan.category}'),
            const SizedBox(height: 12),
            const Text("Deskripsi:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(kegiatan.description ?? '-', style: const TextStyle(color: Colors.black87)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _filterOption('Semua', null),
            _filterOption('Akan Datang', 'upcoming'),
            _filterOption('Berlangsung', 'ongoing'),
            _filterOption('Selesai', 'completed'),
            _filterOption('Dibatalkan', 'cancelled'),
          ],
        ),
      ),
    );
  }

  Widget _filterOption(String title, String? value) {
    return ListTile(
      title: Text(title),
      leading: Radio<String?>(
        value: value,
        groupValue: filterStatus,
        onChanged: (val) {
          setState(() => filterStatus = val);
          Navigator.pop(context);
        },
      ),
      onTap: () {
        setState(() => filterStatus = value);
        Navigator.pop(context);
      },
    );
  }
}