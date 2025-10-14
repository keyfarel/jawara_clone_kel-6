// TODO: Implement penerimaan_warga_page.dart
import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class PenerimaanWargaPage extends StatelessWidget {
  const PenerimaanWargaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'penerimaan warga',
      body: const Center(
        child: Text(
          'Ini adalah page penerimaan warga',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}