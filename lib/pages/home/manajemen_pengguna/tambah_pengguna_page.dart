import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class TambahPenggunaPage extends StatelessWidget {
  const TambahPenggunaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Tambah Pengguna',
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Halaman Tambah Pengguna',
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