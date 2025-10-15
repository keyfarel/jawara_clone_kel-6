import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class SemuaAktifitasPage extends StatelessWidget {
  const SemuaAktifitasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Semua Aktifitas',
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Halaman Semua Aktifitas',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Fitur dalam pengembangan',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}