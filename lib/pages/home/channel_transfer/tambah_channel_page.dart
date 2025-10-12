// file: tambah_channel_page.dart
import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class TambahChannelPage extends StatefulWidget {
  const TambahChannelPage({super.key});

  @override
  State<TambahChannelPage> createState() => _TambahChannelPageState();
}

class _TambahChannelPageState extends State<TambahChannelPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController nomorController = TextEditingController();
  final TextEditingController pemilikController = TextEditingController();
  final TextEditingController catatanController = TextEditingController();

  String? tipeChannel;
  String? qrFile;
  String? thumbnailFile;

  final List<String> tipeList = [
    'Bank',
    'E-Wallet',
    'QRIS',
  ];

  void _resetForm() {
    _formKey.currentState?.reset();
    namaController.clear();
    nomorController.clear();
    pemilikController.clear();
    catatanController.clear();
    setState(() {
      tipeChannel = null;
      qrFile = null;
      thumbnailFile = null;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Simpan data ke backend / database
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Channel berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
      _resetForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Buat Transfer Channel',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildLabel('Nama Channel'),
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  hintText: 'Contoh: BCA, Dana, QRIS RT',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              _buildLabel('Tipe'),
              DropdownButtonFormField<String>(
                value: tipeChannel,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                hint: const Text('-- Pilih Tipe --'),
                items: tipeList
                    .map((tipe) =>
                        DropdownMenuItem(value: tipe, child: Text(tipe)))
                    .toList(),
                onChanged: (value) => setState(() => tipeChannel = value),
                validator: (value) =>
                    value == null ? 'Tipe channel harus dipilih' : null,
              ),
              const SizedBox(height: 16),

              _buildLabel('Nomor Rekening / Akun'),
              TextFormField(
                controller: nomorController,
                decoration: const InputDecoration(
                  hintText: 'Contoh: 1234567890',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Nomor akun wajib diisi'
                    : null,
              ),
              const SizedBox(height: 16),

              _buildLabel('Nama Pemilik'),
              TextFormField(
                controller: pemilikController,
                decoration: const InputDecoration(
                  hintText: 'Contoh: John Doe',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Nama pemilik wajib diisi'
                    : null,
              ),
              const SizedBox(height: 16),

              _buildLabel('QR'),
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implementasi upload file QR
                  setState(() => qrFile = 'qr_image.png');
                },
                icon: const Icon(Icons.upload),
                label: Text(qrFile ?? 'No file chosen'),
              ),
              const SizedBox(height: 16),

              _buildLabel('Thumbnail'),
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implementasi upload file Thumbnail
                  setState(() => thumbnailFile = 'thumbnail_image.png');
                },
                icon: const Icon(Icons.upload),
                label: Text(thumbnailFile ?? 'No file chosen'),
              ),
              const SizedBox(height: 16),

              _buildLabel('Catatan (Opsional)'),
              TextFormField(
                controller: catatanController,
                decoration: const InputDecoration(
                  hintText: 'Contoh: Transfer hanya dari bank yang sama agar instan',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(120, 45),
                    ),
                    child: const Text('Simpan'),
                  ),
                  OutlinedButton(
                    onPressed: _resetForm,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(120, 45),
                    ),
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
