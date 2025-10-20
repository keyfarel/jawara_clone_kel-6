// TODO: Implement daftar_pengguna_page.dart
import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class DaftarPenggunaPage extends StatelessWidget {
  const DaftarPenggunaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'daftar pengguna',
      body: const Center(
        child: Text(
          'Ini adalah page daftar pengguna',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}