// file: rumah_tambah_page.dart
import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class RumahTambahPage extends StatelessWidget {
  const RumahTambahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Tambah Rumah Baru',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nama Pemilik',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Jumlah Penghuni',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Tipe Rumah',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Type A', child: Text('Type A')),
                DropdownMenuItem(value: 'Type B', child: Text('Type B')),
                DropdownMenuItem(value: 'Type C', child: Text('Type C')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Fasilitas Lengkap'),
              value: false,
              onChanged: (value) {},
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // hanya efek visual, tidak ada backend
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tombol simpan ditekan')),
                );
              },
              child: const Text('Simpan Rumah'),
            ),
          ],
        ),
      ),
    );
  }
}
