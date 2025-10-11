// file: home_page.dart
import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class KeuanganPage extends StatelessWidget {
  const KeuanganPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Keuangan',
      body: const Center(
        child: Text(
          'Ini adalah page keuangan',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
