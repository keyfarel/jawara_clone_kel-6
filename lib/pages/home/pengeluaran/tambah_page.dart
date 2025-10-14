import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class TambahPage extends StatelessWidget {
  const TambahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Tambah Pengeluaran',
      body: const Center(
        child: Text(
          'Ini adalah page tambah pengeluaran',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
