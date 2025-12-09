import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../layouts/pages_layout.dart';
import '../../controllers/rumah_controller.dart';

class RumahTambahPage extends StatefulWidget {
  const RumahTambahPage({super.key});

  @override
  State<RumahTambahPage> createState() => _RumahTambahPageState();
}

class _RumahTambahPageState extends State<RumahTambahPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController namaRumahController = TextEditingController(); // Misal: Blok A-10
  final TextEditingController pemilikController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController tipeController = TextEditingController(); // Bisa Dropdown atau Text

  // State
  String? selectedStatus = 'empty'; // Default Tersedia
  bool hasFacilities = false;
  String? selectedType;

  final List<String> houseTypes = ['Type 36', 'Type 45', 'Type 60', 'Type 70', 'Custom'];
  final List<String> statusList = ['empty', 'occupied']; // empty = Tersedia, occupied = Ditempati

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<RumahController, bool>((c) => c.isLoading);

    return PageLayout(
      title: 'Tambah Rumah Baru',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Nama / Nomor Blok Rumah'),
                  TextFormField(
                    controller: namaRumahController,
                    decoration: _inputDecoration('Contoh: Blok B-21'),
                    validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Nama Pemilik'),
                  TextFormField(
                    controller: pemilikController,
                    decoration: _inputDecoration('Contoh: Budi Santoso'),
                    validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Alamat Lengkap'),
                  TextFormField(
                    controller: alamatController,
                    decoration: _inputDecoration('Contoh: Jl. Mawar No. 15'),
                    maxLines: 3,
                    validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Tipe Rumah'),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: _inputDecoration('Pilih Tipe'),
                    items: houseTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                    onChanged: (val) => setState(() => selectedType = val),
                    validator: (val) => val == null ? 'Pilih tipe rumah' : null,
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Status Hunian'),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: _inputDecoration('Pilih Status'),
                    items: const [
                      DropdownMenuItem(value: 'empty', child: Text('Tersedia (Kosong)')),
                      DropdownMenuItem(value: 'occupied', child: Text('Ditempati')),
                    ],
                    onChanged: (val) => setState(() => selectedStatus = val),
                  ),
                  const SizedBox(height: 16),

                  CheckboxListTile(
                    title: const Text('Fasilitas Lengkap'),
                    subtitle: const Text('Listrik, Air, Sanitasi memadai'),
                    value: hasFacilities,
                    onChanged: (val) => setState(() => hasFacilities = val!),
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Simpan Rumah', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final controller = context.read<RumahController>();

      final isSuccess = await controller.addHouse(
        houseName: namaRumahController.text,
        ownerName: pemilikController.text,
        address: alamatController.text,
        houseType: selectedType!,
        hasFacilities: hasFacilities,
        status: selectedStatus!,
      );

      if (!mounted) return;

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rumah berhasil ditambahkan'), backgroundColor: Colors.green),
        );
        Navigator.pop(context); // Kembali ke daftar rumah
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(controller.errorMessage ?? 'Gagal menyimpan'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}