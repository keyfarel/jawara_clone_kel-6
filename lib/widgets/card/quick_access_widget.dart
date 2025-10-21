import 'package:flutter/material.dart';

class QuickAccessWidget extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color? iconColor;
  final List<Map<String, dynamic>> quickAccess;

  const QuickAccessWidget({
    super.key,
    required this.title,
    required this.quickAccess,
    this.icon,
    this.iconColor,
  });

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
                  Icon(
                    icon,
                    color: iconColor ?? Colors.indigoAccent,
                    size: 20,
                  ),
                if (icon != null) const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: iconColor ?? Colors.indigoAccent,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // === Daftar Tombol Horizontal ===
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: quickAccess.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.pushNamed(context, item['route']);
                      },
                      child: Card(
                        color: item['color'],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                        child: Container(
                          width: 140,
                          height: 110,
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(item['icon'], size: 36, color: Colors.black87),
                              const SizedBox(height: 8),
                              Text(
                                item['label'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
