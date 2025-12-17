import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../../../widgets/layouts/pages_layout.dart';
import '../../controllers/mutasi_controller.dart';

class TambahMutasiPage extends StatefulWidget {
  const TambahMutasiPage({super.key});

  @override
  State<TambahMutasiPage> createState() => _TambahMutasiPageState();
}

class _TambahMutasiPageState extends State<TambahMutasiPage> {
  final _formKey = GlobalKey<FormState>();

  String? selectedJenisLabel;
  Map<String, dynamic>? selectedKeluargaData; // Object keluarga terpilih
  
  final TextEditingController alasanController = TextEditingController();
  DateTime? selectedDate;

  // --- DATA STATIS (MAPPING) ---
  final Map<String, String> mutationTypesMap = {
    'Pindah Domisili': 'move_out',
    'Meninggal Dunia': 'deceased',
    'Warga Baru': 'move_in',
    'Pindah Blok': 'internal_move',
  };

  @override
  void initState() {
    super.initState();
    // PANGGIL DATA KELUARGA DARI API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MutasiController>().loadFamilyOptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch Controller
    final controller = context.watch<MutasiController>();
    final isLoading = controller.isLoading; // Loading saat submit
    final isFamilyLoading = controller.isFamilyOptionsLoading; // Loading opsi
    final familyList = controller.familyOptions; // Data opsi

    return PageLayout(
      title: 'Buat Mutasi Keluarga',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
                  // 🔹 Jenis Mutasi (Tetap Statis)
                  const Text('Jenis Mutasi', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: selectedJenisLabel,
                    decoration: _inputDecoration('-- Pilih Jenis Mutasi --'),
                    items: mutationTypesMap.keys.map((label) {
                      return DropdownMenuItem(value: label, child: Text(label));
                    }).toList(),
                    onChanged: (value) => setState(() => selectedJenisLabel = value),
                    validator: (value) => value == null ? 'Pilih jenis mutasi' : null,
                  ),
                  const SizedBox(height: 16),

                  // 🔹 Keluarga (SEKARANG DINAMIS)
                  const Text('Keluarga', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<Map<String, dynamic>>(
                    value: selectedKeluargaData,
                    decoration: _inputDecoration('-- Pilih Keluarga --'),
                    // Jika loading, tampilkan item kosong atau loading text
                    items: isFamilyLoading 
                        ? [] 
                        : familyList.map((keluarga) {
                            return DropdownMenuItem<Map<String, dynamic>>(
                              value: keluarga, // Map {'id': 15, 'nama': 'Bapak...'}
                              child: Text(keluarga['nama']),
                            );
                          }).toList(),
                    onChanged: isFamilyLoading 
                        ? null // Disable saat loading
                        : (value) => setState(() => selectedKeluargaData = value),
                    validator: (value) => value == null ? 'Pilih keluarga' : null,
                    // Hint Text berubah saat loading
                    hint: isFamilyLoading 
                        ? const Text("Memuat data keluarga...")
                        : const Text("-- Pilih Keluarga --"),
                  ),
                  const SizedBox(height: 16),

                  // ... (Field Alasan & Tanggal sama seperti sebelumnya) ...
                  // 🔹 Alasan
                  const Text('Alasan Mutasi', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: alasanController,
                    maxLines: 3,
                    decoration: _inputDecoration('Masukkan alasan disini...'),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Alasan tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // 🔹 Tanggal
                  const Text('Tanggal Mutasi', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: _pickDate,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: _inputDecoration('Pilih tanggal'),
                        controller: TextEditingController(
                          text: selectedDate == null
                              ? ''
                              : DateFormat('dd/MM/yyyy').format(selectedDate!),
                        ),
                        validator: (_) => selectedDate == null ? 'Pilih tanggal' : null,
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
                        onPressed: isLoading ? null : _submitForm,
                        icon: isLoading 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.save),
                        label: Text(isLoading ? 'Menyimpan...' : 'Simpan'),
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
    );
  }

  // ... (Helper _inputDecoration, _resetForm, _pickDate sama seperti sebelumnya) ...
  
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.indigo, width: 1.2)),
    );
  }

  void _resetForm() {
    setState(() {
      selectedJenisLabel = null;
      selectedKeluargaData = null;
      alasanController.clear();
      selectedDate = null;
    });
  }

  void _pickDate() async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
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
    if (picked != null) setState(() => selectedDate = picked);
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // 1. Ambil Data
      final backendType = mutationTypesMap[selectedJenisLabel!]; 
      final familyId = selectedKeluargaData!['id'] as int; // ID asli dari API
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);

      final controller = context.read<MutasiController>();

      // 2. Submit
      final isSuccess = await controller.addMutation(
        familyId: familyId,
        mutationType: backendType!,
        date: formattedDate,
        reason: alasanController.text,
      );

      if (!mounted) return;

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data mutasi keluarga berhasil disimpan!'),
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
}