import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class PemasukanLainTambahPage extends StatelessWidget {
  const PemasukanLainTambahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Pemasukan Lain - Tambah',
      body: const Center(
        child: Text(
          'Ini adalah page Pemasukan Lain - Tambah',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

// TODO: Implement pemasukan_lain_tambah_page.dart