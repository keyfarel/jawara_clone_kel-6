import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/layouts/pages_layout.dart';
import '../../controllers/channel_controller.dart';
import '../widgets/tambah_channel/channel_input_label.dart';
import '../widgets/tambah_channel/image_picker_field.dart';

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

  XFile? _thumbnailFile;
  XFile? _qrFile;

  final ImagePicker _picker = ImagePicker();

  final List<String> tipeList = ['Bank', 'E-Wallet', 'QRIS'];

  String _mapTypeToBackend(String uiType) {
    switch (uiType) {
      case 'Bank':
        return 'bank';
      case 'E-Wallet':
        return 'ewallet';
      case 'QRIS':
        return 'qris';
      default:
        return 'bank';
    }
  }

  Future<void> _pickImage(bool isQr) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        if (isQr) {
          _qrFile = picked;
        } else {
          _thumbnailFile = picked;
        }
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final controller = context.read<ChannelController>();

      final isSuccess = await controller.addChannel(
        name: namaController.text,
        type: _mapTypeToBackend(tipeChannel!),
        accountNumber: nomorController.text,
        accountName: pemilikController.text,
        notes: catatanController.text,
        thumbnail: _thumbnailFile,
        qrCode: _qrFile,
      );

      if (!mounted) return;

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Channel berhasil disimpan!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.errorMessage ?? 'Gagal menyimpan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<ChannelController, bool>(
      (c) => c.isLoading,
    );

    return PageLayout(
      title: 'Buat Transfer Channel',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const ChannelInputLabel('Nama Channel'),
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  hintText: 'Contoh: BCA, Dana, QRIS RT',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              const ChannelInputLabel('Tipe'),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                value: tipeChannel,
                hint: const Text('-- Pilih Tipe --'),
                items: tipeList
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => tipeChannel = v),
                validator: (v) => v == null ? 'Tipe harus dipilih' : null,
              ),
              const SizedBox(height: 16),

              const ChannelInputLabel('Nomor Rekening / Akun'),
              TextFormField(
                controller: nomorController,
                decoration: const InputDecoration(
                  hintText: 'Contoh: 1234567890',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Nomor wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              const ChannelInputLabel('Nama Pemilik'),
              TextFormField(
                controller: pemilikController,
                decoration: const InputDecoration(
                  hintText: 'Contoh: John Doe',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              const ChannelInputLabel('QR Code (Opsional)'),
              ImagePickerField(
                label: "Pilih Gambar QR",
                file: _qrFile,
                onTap: () => _pickImage(true),
              ),
              const SizedBox(height: 16),

              const ChannelInputLabel('Thumbnail / Logo (Opsional)'),
              ImagePickerField(
                label: "Pilih Logo Bank",
                file: _thumbnailFile,
                onTap: () => _pickImage(false),
              ),
              const SizedBox(height: 16),

              const ChannelInputLabel('Catatan (Opsional)'),
              TextFormField(
                controller: catatanController,
                decoration: const InputDecoration(
                  hintText: 'Contoh: Transfer hanya dari bank yang sama',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submitForm,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Simpan Channel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
