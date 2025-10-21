import 'package:flutter/material.dart';

class DoubleHeaderCardWidget extends StatelessWidget {
  final IconData? leftIcon;
  final String leftTitle;
  final String leftValue;

  final IconData? rightIcon;
  final String rightTitle;
  final String rightValue;

  const DoubleHeaderCardWidget({
    super.key,
    this.leftIcon,
    required this.leftTitle,
    required this.leftValue,
    this.rightIcon,
    required this.rightTitle,
    required this.rightValue,
  });

  @override
  Widget build(BuildContext context) {
    const Color iconAndTitleColor = Colors.indigoAccent;
    const Color valueColor = Colors.black;

    Widget buildCard(IconData? icon, String title, String value) {
      return Expanded(
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: iconAndTitleColor, size: 18),
                      const SizedBox(width: 6),
                    ],
                    Flexible(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: iconAndTitleColor, // 🔹 sama seperti icon
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: valueColor, // 🔹 angka warna hitam
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        buildCard(leftIcon, leftTitle, leftValue),
        const SizedBox(width: 12), // 🔹 jarak antar card
        buildCard(rightIcon, rightTitle, rightValue),
      ],
    );
  }
}
