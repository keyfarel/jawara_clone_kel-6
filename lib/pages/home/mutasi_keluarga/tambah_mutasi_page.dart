// file: tambah_page.dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class TambahMutasiPage extends StatefulWidget {
  const TambahMutasiPage({super.key});

  @override
  State<TambahMutasiPage> createState() => _TambahMutasiPageState();
}

class _TambahMutasiPageState extends State<TambahMutasiPage> {
  final _formKey = GlobalKey<FormState>();

  String? selectedJenis;
  String? selectedKeluarga;
  final TextEditingController alasanController = TextEditingController();
  DateTime? selectedDate;

  final List<String> jenisMutasiList = [
    'Pindah Domisili',
    'Meninggal Dunia',
    'Datang dari Luar',
  ];

  final List<String> keluargaList = [
    'Keluarga Santoso',
    'Keluarga Wijaya',
    'Keluarga Rohani',
  ];

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Buat Mutasi Keluarga',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Transform.translate(
          offset: const Offset(0, 2),
          child: Card(
            elevation: 4,
            shadowColor: Colors.grey.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Jenis Mutasi
                    const Text(
                      'Jenis Mutasi',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: selectedJenis,
                      decoration: _inputDecoration('-- Pilih Jenis Mutasi --'),
                      items: jenisMutasiList
                          .map((jenis) => DropdownMenuItem(
                                value: jenis,
                                child: Text(jenis),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedJenis = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Pilih jenis mutasi' : null,
                    ),
                    const SizedBox(height: 16),

                    // 🔹 Keluarga
                    const Text(
                      'Keluarga',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: selectedKeluarga,
                      decoration: _inputDecoration('-- Pilih Keluarga --'),
                      items: keluargaList
                          .map((keluarga) => DropdownMenuItem(
                                value: keluarga,
                                child: Text(keluarga),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedKeluarga = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Pilih keluarga' : null,
                    ),
                    const SizedBox(height: 16),

                    // 🔹 Alasan Mutasi
                    const Text(
                      'Alasan Mutasi',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: alasanController,
                      maxLines: 3,
                      decoration: _inputDecoration(
                          'Masukkan alasan disini...'),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Alasan tidak boleh kosong'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // 🔹 Tanggal Mutasi
                    const Text(
                      'Tanggal Mutasi',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: _pickDate,
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: _inputDecoration('Pilih tanggal'),
                          controller: TextEditingController(
                            text: selectedDate == null
                                ? ''
                                : '${selectedDate!.day.toString().padLeft(2, '0')}/'
                                    '${selectedDate!.month.toString().padLeft(2, '0')}/'
                                    '${selectedDate!.year}',
                          ),
                          validator: (_) =>
                              selectedDate == null ? 'Pilih tanggal' : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 🔹 Tombol Aksi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _resetForm,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _submitForm,
                          icon: const Icon(Icons.save),
                          label: const Text('Simpan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.indigo, width: 1.2),
      ),
    );
  }

  void _resetForm() {
    setState(() {
      selectedJenis = null;
      selectedKeluarga = null;
      alasanController.clear();
      selectedDate = null;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Integrasikan dengan backend / database
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data mutasi keluarga berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _pickDate() async {
    final now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        // 🔹 Bungkus dengan Localizations yang menyediakan GlobalMaterialLocalizations
        return Localizations(
          locale: const Locale('id', 'ID'),
          delegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
