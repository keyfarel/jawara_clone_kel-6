import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Wajib: flutter pub add intl
import '../../../../widgets/layouts/pages_layout.dart';
import '../../controllers/kegiatan_controller.dart';

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
  String? _kategori; // Value backend (social, sport, etc)
  DateTime? _tanggal;
  TimeOfDay? _jam;

  // Mapping Kategori (Label UI -> Value API)
  final Map<String, String> kategoriMap = {
    "Sosial": "social",
    "Olahraga": "sport",
    "Keagamaan": "religious",
    "Pendidikan": "education",
    "Lain-lain": "others"
  };

  @override
  Widget build(BuildContext context) {
    // Watch Loading
    final isLoading = context.select<KegiatanController, bool>((c) => c.isLoading);

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
                  decoration: _inputDecoration("Contoh: Kerja Bakti"),
                  validator: (val) =>
                      val == null || val.isEmpty ? "Nama wajib diisi" : null,
                ),
                const SizedBox(height: 16),

                // Kategori
                _buildLabel("Kategori Kegiatan"),
                DropdownButtonFormField<String>(
                  value: _kategori,
                  decoration: _inputDecoration("-- Pilih Kategori --"),
                  items: kategoriMap.entries.map((entry) {
                    return DropdownMenuItem(
                      value: entry.value, // Kirim value lowercase ke backend
                      child: Text(entry.key), // Tampilkan Label
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _kategori = val),
                  validator: (val) =>
                      val == null ? "Pilih kategori dulu" : null,
                ),
                const SizedBox(height: 16),

                // Tanggal & Jam
                _buildLabel("Waktu Pelaksanaan"),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: TextEditingController(
                          text: _tanggal == null
                              ? ""
                              : DateFormat('dd MMM yyyy').format(_tanggal!),
                        ),
                        decoration: _inputDecoration("Tanggal",
                            suffixIcon: const Icon(Icons.calendar_today)),
                        onTap: _pickDate,
                        validator: (_) =>
                            _tanggal == null ? "Wajib diisi" : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: TextEditingController(
                          text: _jam == null ? "" : _jam!.format(context),
                        ),
                        decoration: _inputDecoration("Jam",
                            suffixIcon: const Icon(Icons.access_time)),
                        onTap: _pickTime,
                        validator: (_) => _jam == null ? "Wajib diisi" : null,
                      ),
                    ),
                  ],
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
                  decoration: _inputDecoration("Contoh: Pak RT"),
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
                  decoration: _inputDecoration("Detail kegiatan..."),
                ),
                const SizedBox(height: 24),

                // Tombol
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: isLoading 
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text("Submit", style: TextStyle(color: Colors.white, fontSize: 16)),
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
                        child: const Text("Reset", style: TextStyle(color: Color(0xFF6C63FF))),
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

  // --- Logic ---

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _tanggal = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _jam = picked);
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    // Gabungkan Tanggal & Jam menjadi format DateTime String (YYYY-MM-DD HH:mm:ss)
    final dt = DateTime(
      _tanggal!.year, _tanggal!.month, _tanggal!.day, 
      _jam!.hour, _jam!.minute
    );
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dt);

    final controller = context.read<KegiatanController>();

    final isSuccess = await controller.addActivity(
      name: _namaController.text,
      category: _kategori!,
      date: formattedDate,
      location: _lokasiController.text,
      personInCharge: _penanggungJawabController.text,
      description: _deskripsiController.text,
    );

    if (!mounted) return;

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kegiatan berhasil ditambahkan!"), backgroundColor: Colors.green),
      );
      Navigator.pop(context); // Kembali ke daftar
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(controller.errorMessage ?? "Gagal menyimpan"), backgroundColor: Colors.red),
      );
    }
  }

  void _resetForm() {
    _namaController.clear();
    _lokasiController.clear();
    _penanggungJawabController.clear();
    _deskripsiController.clear();
    setState(() {
      _kategori = null;
      _tanggal = null;
      _jam = null;
    });
  }

  // --- Widgets ---

  InputDecoration _inputDecoration(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }
}