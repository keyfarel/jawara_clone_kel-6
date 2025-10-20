// TODO: Implement cetak_laporan_page.dart
import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class CetakLaporanPage extends StatelessWidget {
  const CetakLaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'cetak laporan',
      body: const Center(
        child: Text(
          'Ini adalah page cetak laporan',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}