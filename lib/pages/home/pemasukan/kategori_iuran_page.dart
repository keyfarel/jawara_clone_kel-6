import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class KategoriIuranPage extends StatelessWidget {
  const KategoriIuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Kategori Iuran',
      body: const Center(
        child: Text(
          'Ini adalah page Kategori iuran',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}