import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/models/pemasukan_lain.model.dart';
import '../../../layouts/pages_layout.dart';

class PemasukanLainTambahPage extends StatefulWidget {
  const PemasukanLainTambahPage({super.key});

  @override
  State<PemasukanLainTambahPage> createState() =>
      _PemasukanLainTambahPageState();
}

class _PemasukanLainTambahPageState extends State<PemasukanLainTambahPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller
  final _namaController = TextEditingController();
  final _nominalController = TextEditingController();

  String? _kategori;
  DateTime? _tanggal;
  File? _buktiImage;

  final List<String> kategoriList = [
    "Pendapatan Lainnya",
    "Donasi",
    "Lain-lain"
  ];

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Tambah Pemasukan Lain',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Buat Pemasukan Non Iuran Baru",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Nama Pemasukan
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: "Nama Pemasukan",
                    hintText: "Masukkan nama pemasukan",
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                  val == null || val.isEmpty ? "Nama wajib diisi" : null,
                ),
                const SizedBox(height: 16),

                // Tanggal Pemasukan
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Tanggal Pemasukan",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: _pickDate,
                    ),
                    hintText: _tanggal == null
                        ? "--/--/----"
                        : "${_tanggal!.day}/${_tanggal!.month}/${_tanggal!.year}",
                  ),
                  validator: (_) =>
                  _tanggal == null ? "Tanggal belum dipilih" : null,
                ),
                const SizedBox(height: 16),

                // Kategori Pemasukan
                DropdownButtonFormField<String>(
                  value: _kategori,
                  decoration: const InputDecoration(
                    labelText: "Kategori Pemasukan",
                    border: OutlineInputBorder(),
                  ),
                  items: kategoriList
                      .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                      .toList(),
                  onChanged: (val) => setState(() => _kategori = val),
                  validator: (val) =>
                  val == null ? "Pilih kategori dulu" : null,
                ),
                const SizedBox(height: 16),

                // Nominal
                TextFormField(
                  controller: _nominalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Nominal",
                    hintText: "Masukkan jumlah nominal",
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Nominal wajib diisi";
                    }
                    final n = double.tryParse(val);
                    if (n == null || n <= 0) return "Nominal tidak valid";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Bukti Pemasukan
                const Text(
                  "Bukti Pemasukan",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(
                        color: Colors.grey.shade400,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _buktiImage == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.cloud_upload,
                            size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          "Upload bukti pemasukan (.png / .jpg)",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _buktiImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Tombol Aksi
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _submitForm,
                        child: const Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _resetForm,
                        child: const Text("Reset"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========================
  // FUNCTIONS
  // ========================

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _tanggal = picked);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _buktiImage = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    if (_buktiImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan upload bukti pemasukan dulu")),
      );
      return;
    }

    final pemasukan = PemasukanLain(
      no: 0,
      nama: _namaController.text,
      kategori: _kategori!,
      tanggal:
      "${_tanggal!.day}/${_tanggal!.month}/${_tanggal!.year}",
      nominal: double.parse(_nominalController.text),
      tanggalVerifikasi: "-",
      verifikator: "-",
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Berhasil disimpan: ${pemasukan.nama}")),
    );

    // TODO: kirim data + file ke backend
  }

  void _resetForm() {
    _namaController.clear();
    _nominalController.clear();
    setState(() {
      _kategori = null;
      _tanggal = null;
      _buktiImage = null;
    });
  }
}
