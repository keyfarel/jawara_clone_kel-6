import 'package:flutter/material.dart';
import '../informasi_aspirasi_page.dart';

void showAspirasiDetailSheet(BuildContext context, Aspirasi aspirasi) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (context) {
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
                aspirasi.judul,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 20),
              _detailRow("Pengirim", aspirasi.pengirim),
              _detailRow("Tanggal", aspirasi.tanggal),
              _detailRow(
                "Status",
                aspirasi.status,
                color: _getStatusColor(aspirasi.status),
              ),
              const SizedBox(height: 10),
              _detailRow("Deskripsi", aspirasi.deskripsi, multiline: true),
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
              const SizedBox(height: 10),
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
    case 'diproses':
      return Colors.blue;
    case 'selesai':
      return Colors.green;
    default:
      return Colors.grey;
  }
}
