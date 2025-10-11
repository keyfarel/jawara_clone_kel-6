import 'package:flutter/material.dart';

class LoginFormSection extends StatelessWidget {
  const LoginFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Email
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Email', style: TextStyle(fontSize: 14, color: Colors.black87)),
        ),
        const SizedBox(height: 6),
        TextField(
          decoration: InputDecoration(
            hintText: 'Masukkan email disini',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        const SizedBox(height: 16),

        // Password
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Password', style: TextStyle(fontSize: 14, color: Colors.black87)),
        ),
        const SizedBox(height: 6),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Masukkan password disini',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
