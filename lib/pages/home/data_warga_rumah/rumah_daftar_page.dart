import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class RumahDaftarPage extends StatelessWidget {
  const RumahDaftarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Rumah - Daftar',
      body: const Center(
        child: Text(
          'Ini adalah page Rumah - Daftar',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

// TODO: Implement rumah_daftar_page.dart