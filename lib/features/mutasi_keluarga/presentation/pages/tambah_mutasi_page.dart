import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../../../widgets/layouts/pages_layout.dart';
import '../../controllers/mutasi_controller.dart';
import '../../../dashboard/controllers/dashboard_controller.dart';

class TambahMutasiPage extends StatefulWidget {
  const TambahMutasiPage({super.key});

  @override
  State<TambahMutasiPage> createState() => _TambahMutasiPageState();
}

class _TambahMutasiPageState extends State<TambahMutasiPage> {
  final _formKey = GlobalKey<FormState>();

  // State Form
  String? selectedJenisLabel;
  Map<String, dynamic>? selectedKeluargaData;
  int? selectedCitizenId; // ID Warga terpilih
  
  final TextEditingController alasanController = TextEditingController();
  DateTime? selectedDate;

  // Mapping Frontend -> Backend
  final Map<String, String> mutationTypesMap = {
    'Pindah Domisili': 'move_out',
    'Meninggal Dunia': 'deceased',
    'Warga Baru': 'move_in',
    'Pindah Blok': 'internal_move',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MutasiController>().loadFamilyOptions();
    });
  }

  // Reset semua form
  void _resetForm() {
    setState(() {
      selectedJenisLabel = null;
      selectedKeluargaData = null;
      selectedCitizenId = null;
      alasanController.clear();
      selectedDate = null;
    });
    // Reset list warga di controller juga (opsional)
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final backendType = mutationTypesMap[selectedJenisLabel!]; 
      final familyId = selectedKeluargaData!['id'] as int;
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);

      final controller = context.read<MutasiController>();

      // Logic Khusus: Passing citizenId ke Controller
      // (Pastikan controller.addMutation sudah diupdate untuk kirim JSON citizen_id)
      final isSuccess = await controller.addMutation(
        familyId: familyId,
        citizenId: selectedCitizenId, // Kirim ID warga (bisa null)
        mutationType: backendType!,
        date: formattedDate,
        reason: alasanController.text,
      );

      if (!mounted) return;

      if (isSuccess) {
        context.read<DashboardController>().refreshData(); // Refresh Dashboard
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data mutasi berhasil disimpan!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(controller.errorMessage ?? 'Gagal menyimpan'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MutasiController>();
    
    // Cek apakah jenis mutasi = Meninggal Dunia (Wajib pilih orang)
    final isDeceasedType = mutationTypesMap[selectedJenisLabel] == 'deceased';

    return PageLayout(
      title: 'Buat Mutasi Keluarga',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200)
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. JENIS MUTASI
                  const Text('Jenis Mutasi', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: selectedJenisLabel,
                    decoration: _inputDecoration('Pilih Jenis Mutasi', Icons.category),
                    items: mutationTypesMap.keys.map((label) {
                      return DropdownMenuItem(value: label, child: Text(label));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                         selectedJenisLabel = value;
                         // Jika ganti jenis, validasi citizen mungkin berubah, jadi reset citizenId jika mau aman
                         // selectedCitizenId = null; 
                      });
                    },
                    validator: (value) => value == null ? 'Wajib dipilih' : null,
                  ),
                  const SizedBox(height: 16),

                  // 2. KELUARGA
                  const Text('Keluarga', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<Map<String, dynamic>>(
                    value: selectedKeluargaData,
                    decoration: _inputDecoration('Pilih Keluarga', Icons.family_restroom),
                    items: controller.familyOptions.map((keluarga) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: keluarga, 
                          child: Text(keluarga['nama']),
                        );
                      }).toList(),
                    onChanged: controller.isFamilyOptionsLoading 
                        ? null 
                        : (value) {
                            setState(() {
                              selectedKeluargaData = value;
                              selectedCitizenId = null; // Reset warga saat ganti keluarga
                            });
                            // Load Warga Keluarga ini
                            if (value != null) {
                              controller.loadCitizensByFamily(value['id']);
                            }
                          },
                    validator: (value) => value == null ? 'Wajib dipilih' : null,
                  ),
                  const SizedBox(height: 16),

                  // 3. ANGGOTA KELUARGA (DINAMIS)
                  // Hanya muncul jika keluarga sudah dipilih
                  if (selectedKeluargaData != null) ...[
                     Text(
                       isDeceasedType 
                          ? 'Anggota yang Meninggal (Wajib)' 
                          : 'Anggota Spesifik (Opsional - Kosongkan jika sekeluarga)', 
                       style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)
                     ),
                     const SizedBox(height: 6),
                     DropdownButtonFormField<int>(
                       value: selectedCitizenId,
                       decoration: _inputDecoration(
                         controller.isCitizensLoading ? 'Memuat data...' : 'Pilih Nama Warga', 
                         Icons.person
                       ),
                       items: controller.citizensOptions.map((citizen) {
                          return DropdownMenuItem<int>(
                             value: citizen['id'],
                             child: Text("${citizen['name']} (${citizen['family_role']})"),
                          );
                       }).toList(),
                       onChanged: (val) => setState(() => selectedCitizenId = val),
                       validator: (val) {
                          // Validasi Khusus: Jika Meninggal, Wajib pilih orang
                          if (isDeceasedType && val == null) {
                             return "Wajib memilih siapa yang meninggal";
                          }
                          return null;
                       },
                     ),
                     const SizedBox(height: 16),
                  ],

                  // 4. ALASAN
                  const Text('Alasan / Keterangan', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: alasanController,
                    maxLines: 3,
                    decoration: _inputDecoration('Tulis alasan lengkap...', Icons.note),
                    validator: (val) => (val == null || val.isEmpty) ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  // 5. TANGGAL
                  const Text('Tanggal Kejadian', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextFormField(
                    readOnly: true,
                    onTap: _pickDate,
                    decoration: _inputDecoration(
                      selectedDate == null ? 'Pilih Tanggal' : DateFormat('dd MMMM yyyy', 'id_ID').format(selectedDate!),
                      Icons.calendar_today
                    ),
                    controller: TextEditingController(text: selectedDate == null ? '' : ' '), // Hack biar validator jalan
                    validator: (_) => selectedDate == null ? 'Wajib dipilih' : null,
                  ),
                  const SizedBox(height: 24),

                  // TOMBOL AKSI
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _resetForm,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                          ),
                          child: const Text("Reset"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: controller.isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                          ),
                          child: controller.isLoading 
                             ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                             : const Text("Simpan Mutasi"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- UI Helpers ---
  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
    );
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
}