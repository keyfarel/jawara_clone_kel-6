import 'package:flutter/material.dart';
import 'package:myapp/models/kegiatan_model.dart';
import '../../../layouts/pages_layout.dart';

class KegiatanTambahPage extends StatefulWidget {
  const KegiatanTambahPage({super.key});

  @override
  State<KegiatanTambahPage> createState() => _KegiatanTambahPageState();
}

class _KegiatanTambahPageState extends State<KegiatanTambahPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _namaController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _penanggungJawabController = TextEditingController();
  final _deskripsiController = TextEditingController();

  // State
  String? _kategori;
  DateTime? _tanggal;

  final List<String> kategoriList = [
    "Musyawarah",
    "Kerja Bakti",
    "Rapat Warga",
    "Lomba",
    "Lain-lain"
  ];

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Tambah Kegiatan Baru',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Buat Kegiatan Baru",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 24),

                // Nama Kegiatan
                _buildLabel("Nama Kegiatan"),
                TextFormField(
                  controller: _namaController,
                  decoration: _inputDecoration("Contoh: Musyawarah Warga"),
                  validator: (val) =>
                  val == null || val.isEmpty ? "Nama wajib diisi" : null,
                ),
                const SizedBox(height: 16),

                // Kategori
                _buildLabel("Kategori Kegiatan"),
                DropdownButtonFormField<String>(
                  value: _kategori,
                  decoration: _inputDecoration("-- Pilih Kategori --"),
                  items: kategoriList
                      .map((k) => DropdownMenuItem(
                    value: k,
                    child: Text(k),
                  ))
                      .toList(),
                  onChanged: (val) => setState(() => _kategori = val),
                  validator: (val) =>
                  val == null ? "Pilih kategori dulu" : null,
                ),
                const SizedBox(height: 16),

                // Tanggal
                _buildLabel("Tanggal"),
                TextFormField(
                  readOnly: true,
                  decoration: _inputDecoration(
                    _tanggal == null
                        ? "--/--/----"
                        : "${_tanggal!.day}/${_tanggal!.month}/${_tanggal!.year}",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: _pickDate,
                    ),
                  ),
                  validator: (_) =>
                  _tanggal == null ? "Tanggal belum dipilih" : null,
                ),
                const SizedBox(height: 16),

                // Lokasi
                _buildLabel("Lokasi"),
                TextFormField(
                  controller: _lokasiController,
                  decoration: _inputDecoration("Contoh: Balai RT 03"),
                  validator: (val) =>
                  val == null || val.isEmpty ? "Lokasi wajib diisi" : null,
                ),
                const SizedBox(height: 16),

                // Penanggung Jawab
                _buildLabel("Penanggung Jawab"),
                TextFormField(
                  controller: _penanggungJawabController,
                  decoration: _inputDecoration("Contoh: Pak RT atau Bu RW"),
                  validator: (val) => val == null || val.isEmpty
                      ? "Penanggung jawab wajib diisi"
                      : null,
                ),
                const SizedBox(height: 16),

                // Deskripsi
                _buildLabel("Deskripsi"),
                TextFormField(
                  controller: _deskripsiController,
                  maxLines: 4,
                  decoration: _inputDecoration(
                      "Tuliskan detail event seperti agenda, keperluan, dll."),
                ),
                const SizedBox(height: 24),

                // Tombol
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Submit",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _resetForm,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF6C63FF)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Reset",
                          style: TextStyle(color: Color(0xFF6C63FF)),
                        ),
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

  InputDecoration _inputDecoration(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _tanggal = picked);
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final kegiatan = Kegiatan(
      id: 0,
      nama: _namaController.text,
      kategori: _kategori!,
      tanggal:
      "${_tanggal!.day}/${_tanggal!.month}/${_tanggal!.year}",
      lokasi: _lokasiController.text,
      penanggungJawab: _penanggungJawabController.text,
      deskripsi: _deskripsiController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Kegiatan '${kegiatan.nama}' berhasil ditambahkan!"),
        backgroundColor: const Color(0xFF6C63FF),
      ),
    );
  }

  void _resetForm() {
    _namaController.clear();
    _lokasiController.clear();
    _penanggungJawabController.clear();
    _deskripsiController.clear();
    setState(() {
      _kategori = null;
      _tanggal = null;
    });
  }
}
