import 'package:flutter/material.dart';
import '../informasi_aspirasi_page.dart';
import 'aspirasi_detail_sheet.dart';

class AspirasiCardWidget extends StatelessWidget {
  final Aspirasi aspirasi;
  final VoidCallback onDetailPressed;

  const AspirasiCardWidget({
    super.key,
    required this.aspirasi,
    required this.onDetailPressed,
  });

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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    aspirasi.judul,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _getStatusColor(aspirasi.status).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    aspirasi.status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(aspirasi.status),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),
            Text(
              "Tanggal: ${aspirasi.tanggal}",
              style: TextStyle(color: Colors.grey[700], fontSize: 12),
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 8),

            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "Pengirim: ",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  TextSpan(
                    text: aspirasi.pengirim,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              aspirasi.deskripsi,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),

            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onDetailPressed,
                icon: const Icon(Icons.info_outline, size: 18),
                label: const Text("Lihat Detail"),
                style: TextButton.styleFrom(foregroundColor: Colors.indigo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
