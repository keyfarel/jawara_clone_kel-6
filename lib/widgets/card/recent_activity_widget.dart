import 'package:flutter/material.dart';

class RecentActivityWidget extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color? iconColor;
  final Color? labelColor;
  final List<Map<String, String>> activities;

  const RecentActivityWidget({
    super.key,
    required this.title,
    required this.activities,
    this.icon,
    this.iconColor,
    this.labelColor,
  });

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Selesai':
        return Colors.green;
      case 'Berlangsung':
        return Colors.orange;
      case 'Akan Datang':
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Judul dan Icon ===
            Row(
              children: [
                if (icon != null)
                  Icon(icon, color: iconColor ?? Colors.blueAccent, size: 18),
                if (icon != null) const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: labelColor ?? Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // === Daftar Kegiatan ===
            Column(
              children: activities.map((item) {
                final status = item['status'] ?? '';
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    leading: Icon(
                      Icons.event,
                      size: 22,
                      color: _getStatusColor(status),
                    ),
                    title: Text(
                      item['judul'] ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Tanggal: ${item['tanggal'] ?? '-'}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Text(
                      status,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
