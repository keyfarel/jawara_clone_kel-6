import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import untuk format tanggal
import '../../data/models/aspirasi_model.dart'; // Import model baru

void showAspirasiDetailSheet(BuildContext context, AspirasiModel aspirasi) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (context) {
      // Format tanggal agar sama dengan di Card
      String formattedDate = DateFormat('dd MMMM yyyy, HH:mm').format(aspirasi.createdAt);

      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Text(
                aspirasi.title, // Ganti judul ke title
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 20),
              _detailRow("Pengirim", aspirasi.user.email), // Ganti pengirim ke user.email
              _detailRow("Tanggal", formattedDate),
              _detailRow(
                "Status",
                aspirasi.status.toUpperCase(),
                color: _getStatusColor(aspirasi.status),
              ),
              const SizedBox(height: 10),
              _detailRow("Deskripsi", aspirasi.description, multiline: true), // Ganti deskripsi ke description
              const SizedBox(height: 25),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text("Tutup"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
}

Widget _detailRow(String label, String value,
    {Color? color, bool multiline = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment:
          multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
            ),
          ),
        ),
        const Text(":", style: TextStyle(fontSize: 13.5)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.5,
              color: color ?? Colors.black87,
              fontWeight: color != null ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ],
    ),
  );
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Colors.orange;
    case 'process': // Tambahkan case sesuai kemungkinan status dari API
    case 'diproses':
      return Colors.blue;
    case 'completed':
    case 'selesai':
      return Colors.green;
    default:
      return Colors.grey;
  }
}