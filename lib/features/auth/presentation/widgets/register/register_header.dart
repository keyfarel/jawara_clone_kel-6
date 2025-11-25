import 'package:flutter/material.dart';

class RegisterHeader extends StatelessWidget {
  final Color primaryColor;

  const RegisterHeader({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Icon(Icons.home_work_rounded, size: 48, color: primaryColor),
        const SizedBox(height: 16),
        Text(
          "Buat Akun Baru",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.blueGrey.shade900,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Bergabunglah bersama warga lainnya",
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}