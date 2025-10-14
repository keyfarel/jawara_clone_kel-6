import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class PemasukanLainDaftarPage extends StatelessWidget {
  const PemasukanLainDaftarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Pemasukan Lain - Daftar',
      body: const Center(
        child: Text(
          'Ini adalah page Pemasukan Lain - Daftar',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
// TODO: Implement pemasukan_lain_daftar_page.dart