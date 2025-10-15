import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class KegiatanDaftarPage extends StatefulWidget {
  const KegiatanDaftarPage({super.key});

  @override
  State<KegiatanDaftarPage> createState() => _KegiatanDaftarPageState();
}

class _KegiatanDaftarPageState extends State<KegiatanDaftarPage> {
  List<Map<String, String>> daftarKegiatan = [
    {
      'id': '1',
      'nama': 'Kerja Bakti Lingkungan',
      'tanggal': '2024-01-15',
      'lokasi': 'Lapangan RT 01',
      'status': 'Akan Datang'
    },
    {
      'id': '2',
      'nama': 'Rapat Warga Bulanan',
      'tanggal': '2024-01-10',
      'lokasi': 'Balai Warga',
      'status': 'Selesai'
    },
    {
      'id': '3',
      'nama': 'Posyandu Lansia',
      'tanggal': '2024-01-20',
      'lokasi': 'Posyandu Melati',
      'status': 'Akan Datang'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Daftar Kegiatan',
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _showSearchDialog,
        ),
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: _showFilterDialog,
        ),
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke tambah kegiatan
        },
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: daftarKegiatan.length,
        itemBuilder: (context, index) {
          final kegiatan = daftarKegiatan[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            elevation: 2,
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.event,
                  color: Colors.blue[700],
                ),
              ),
              title: Text(
                kegiatan['nama']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        kegiatan['tanggal']!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        kegiatan['lokasi']!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(kegiatan['status']!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  kegiatan['status']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                _showDetailKegiatan(kegiatan);
              },
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Akan Datang':
        return Colors.orange;
      case 'Sedang Berlangsung':
        return Colors.green;
      case 'Selesai':
        return Colors.blue;
      case 'Dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showDetailKegiatan(Map<String, String> kegiatan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          kegiatan['nama']!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text('Tanggal: ${kegiatan['tanggal']}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text('Lokasi: ${kegiatan['lokasi']}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.info, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text('Status: ${kegiatan['status']}'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          TextButton(
            onPressed: () {
              // Edit kegiatan
              Navigator.pop(context);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cari Kegiatan'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Masukkan nama kegiatan...',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            // Implementasi pencarian
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implementasi pencarian
              Navigator.pop(context);
            },
            child: const Text('Cari'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Kegiatan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.all_inclusive),
              title: const Text('Semua Status'),
              onTap: () {
                // Filter semua
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.schedule, color: Colors.orange),
              title: const Text('Akan Datang'),
              onTap: () {
                // Filter akan datang
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: const Text('Selesai'),
              onTap: () {
                // Filter selesai
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel, color: Colors.red),
              title: const Text('Dibatalkan'),
              onTap: () {
                // Filter dibatalkan
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}