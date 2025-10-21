import 'package:flutter/material.dart';

class HeaderCardWidget extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String value;
  final String? description;
  final Color? color;

  const HeaderCardWidget({
    super.key,
    this.icon,
    required this.title,
    required this.value,
    this.description,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      color: color ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Baris atas: icon + title
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: theme.primaryColor, size: 22),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // 🔹 Angka / Value
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),

            // 🔹 Deskripsi opsional
            if (description != null) ...[
              const SizedBox(height: 6),
              Text(
                description!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.black54,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
