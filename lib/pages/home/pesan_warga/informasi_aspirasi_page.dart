// file: informasi_aspirasi_page.dart
import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

// --- 1. Model Data Sederhana untuk Aspirasi ---
class Aspirasi {
  final String no;
  final String pengirim;
  final String judul;
  final String deskripsi;
  final String status;
  final String tanggal;

  Aspirasi({
    required this.no,
    required this.pengirim,
    required this.judul,
    required this.deskripsi,
    required this.status,
    required this.tanggal,
  });
}


class InformasiAspirasiPage extends StatefulWidget {
  const InformasiAspirasiPage({super.key});

  @override
  State<InformasiAspirasiPage> createState() => _InformasiAspirasiPageState();
}

class _InformasiAspirasiPageState extends State<InformasiAspirasiPage> {
  // --- 2. Data diubah menjadi List<Aspirasi> ---
  final List<Aspirasi> daftarAspirasi = [
    Aspirasi(
      no: "1",
      pengirim: "Habibie Ed Dien",
      judul: "Tes",
      deskripsi: "Ini adalah deskripsi aspirasi tes untuk menunjukkan fungsionalitas detail.",
      status: "Pending",
      tanggal: "28 September 2025",
    ),
    Aspirasi(
      no: "2",
      pengirim: "Andi Saputra",
      judul: "Perbaikan Lampu Jalan",
      deskripsi: "Lampu jalan di sepanjang Jl. Kenangan banyak yang mati, mohon segera diperbaiki demi keamanan warga.",
      status: "Selesai",
      tanggal: "10 Oktober 2025",
    ),
    Aspirasi(
      no: "3",
      pengirim: "Siti Rohani",
      judul: "Pengajuan Taman Bermain",
      deskripsi: "Warga RT 05 mengajukan pembangunan taman bermain anak-anak di lahan kosong dekat pos ronda.",
      status: "Diproses",
      tanggal: "5 Oktober 2025",
    ),
    Aspirasi(
      no: "4",
      pengirim: "Budi Santoso",
      judul: "Pembersihan Saluran Air",
      deskripsi: "Saluran air di depan gang 5 tersumbat dan menimbulkan bau tak sedap. Perlu segera dibersihkan.",
      status: "Pending",
      tanggal: "20 Oktober 2025",
    ),
  ];

  String? selectedStatus; // Filter status aspirasi

  @override
  Widget build(BuildContext context) {
    // Filter daftar aspirasi berdasarkan status
    final List<Aspirasi> filteredList = selectedStatus == null
        ? daftarAspirasi
        : daftarAspirasi
            .where((a) => a.status == selectedStatus)
            .toList();

    return PageLayout(
      title: "Informasi Aspirasi",
      // Tambahkan ikon filter di AppBar (sama seperti KeluargaDaftarPage)
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_alt),
          onPressed: () {
            _showFilterDialog(context);
          },
        ),
      ],
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          final aspirasi = filteredList[index];
          // Menggunakan Card dan ListTile untuk responsivitas
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              // CircleAvatar dengan inisial pengirim
              leading: CircleAvatar(
                backgroundColor: _getStatusColor(aspirasi.status),
                child: Text(
                  aspirasi.pengirim.isNotEmpty
                      ? aspirasi.pengirim[0].toUpperCase()
                      : '?',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              // Judul Aspirasi
              title: Text(
                aspirasi.judul,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              // Subtitle berisi Pengirim dan Status
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pengirim: ${aspirasi.pengirim}"),
                  Text(
                    "Status: ${aspirasi.status} - ${aspirasi.tanggal}",
                    style: TextStyle(
                      color: _getStatusColor(aspirasi.status),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              isThreeLine: true,
              // Tombol Aksi (titik tiga) diganti dengan onTap yang mengarah ke detail
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (String result) {
                  switch (result) {
                    case 'detail':
                      _showDetail(context, aspirasi); // Memanggil detail via bottom sheet
                      break;
                    case 'edit':
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Edit Aspirasi: ${aspirasi.judul}')),
                      );
                      break;
                    case 'delete':
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Hapus Aspirasi: ${aspirasi.judul}')),
                      );
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'detail',
                    child: Text('Detail'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Hapus'),
                  ),
                ],
              ),
              onTap: () {
                _showDetail(context, aspirasi); // Tetap tambahkan onTap pada ListTile
              },
            ),
          );
        },
      ),
    );
  }

  // --- Fungsi Bantuan ---

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'diproses':
        return Colors.blue;
      case 'selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // === FILTER DIALOG (diadaptasi dari KeluargaDaftarPage) ===
  void _showFilterDialog(BuildContext context) {
    String? tempStatus = selectedStatus;
    final List<String> statusOptions = ["Pending", "Diproses", "Selesai"];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filter Aspirasi"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) {
              return DropdownButtonFormField<String>(
                value: tempStatus,
                items: statusOptions
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (val) {
                  setStateDialog(() {
                    tempStatus = val;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Pilih Status",
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedStatus = null; // Reset filter
                });
                Navigator.pop(context);
              },
              child: const Text("Reset"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  selectedStatus = tempStatus; // Terapkan filter
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

  // === DETAIL ASPIRASI (diadaptasi dari KeluargaDaftarPage menjadi Bottom Sheet) ===
  void _showDetail(BuildContext context, Aspirasi aspirasi) {
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
                  "Detail Aspirasi: ${aspirasi.judul}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),

                _DetailTile(
                  title: "Pengirim",
                  subtitle: aspirasi.pengirim,
                ),
                _DetailTile(
                  title: "Tanggal Dibuat",
                  subtitle: aspirasi.tanggal,
                ),
                _DetailTile(
                  title: "Status",
                  subtitle: aspirasi.status,
                  color: _getStatusColor(aspirasi.status),
                ),
                _DetailTile(
                  title: "Deskripsi Aspirasi",
                  subtitle: aspirasi.deskripsi,
                ),

                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text("Tutup"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// --- Widget Bantuan (Diadaptasi untuk Bottom Sheet) ---

class _DetailTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color? color;

  const _DetailTile({
    required this.title,
    required this.subtitle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: color ?? Colors.black87,
          fontWeight: color != null ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}

// Catatan: Widget _HeaderCell, _DataCell, dan _StatusBadge dari kode lama
// sudah tidak digunakan karena layout sudah diubah menjadi Card/ListTile.