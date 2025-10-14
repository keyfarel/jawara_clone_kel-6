import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class KegiatanTambahPage extends StatelessWidget {
  const KegiatanTambahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Kegiatan - Tambah',
      body: const Center(
        child: Text(
          'Ini adalah page Kegiatan - Tambah',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

// TODO: Implement kegiatan_tambah_page.dart