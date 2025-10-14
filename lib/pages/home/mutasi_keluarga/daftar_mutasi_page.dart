import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class DaftarMutasiPage extends StatelessWidget {
  const DaftarMutasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Mutasi Keluarga - Daftar',
      body: const Center(
        child: Text(
          'Ini adalah page Mutasi Keluarga - Daftar',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

// TODO: Implement daftar_mutasi_page.dart