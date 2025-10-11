// file: home_page.dart
import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class KegiatanPage extends StatelessWidget {
  const KegiatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Kegiatan',
      body: const Center(
        child: Text(
          'Ini adalah page kegiatan',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
