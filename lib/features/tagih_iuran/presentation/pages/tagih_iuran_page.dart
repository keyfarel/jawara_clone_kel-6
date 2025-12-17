// TODO: Implement tagih_iuran_page.dart
// 1. Buat file: lib/pages/home/tagih_iuran_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../widgets/layouts/pages_layout.dart';

// Import Billing Controller & Model
import '../../controllers/billing_controller.dart';
import '../../data/models/billing_model.dart';
import '../../data/repository/billing_repository.dart';
import '../../data/services/billing_service.dart';

class TagihIuranPage extends StatefulWidget {
  const TagihIuranPage({super.key});

  @override
  State<TagihIuranPage> createState() => _TagihIuranPageState();
}

class _TagihIuranPageState extends State<TagihIuranPage> {
  final _formKey = GlobalKey<FormState>();
  final _jumlahController = TextEditingController();
  
  // DUMMY DATA - HARUS diganti dengan data fetch dari API Warga/Keluarga & Kategori Iuran
  // Family ID 1 = Kepala Keluarga A
  final List<Map<String, dynamic>> _dummyFamilies = [
    {'id': 1, 'name': 'Keluarga Ahmad (ID: 1)'},
    {'id': 2, 'name': 'Keluarga Siti (ID: 2)'},
    {'id': 3, 'name': 'Keluarga Budi (ID: 3)'},
  ];

  // Dues Type ID 3 = Dana Sosial (misal)
  final List<Map<String, dynamic>> _dummyDuesTypes = [
    {'id': 1, 'name': 'Iuran Kebersihan', 'default_amount': 25000.0},
    {'id': 2, 'name': 'Iuran Keamanan', 'default_amount': 50000.0},
    {'id': 3, 'name': 'Dana Sosial', 'default_amount': 10000.0},
  ];

  // State yang akan dikirim ke API
  int? _selectedFamilyId;
  int? _selectedDuesTypeId;
  DateTime _selectedDate = DateTime.now(); // Digunakan untuk mendapatkan 'period'

  @override
  void dispose() {
    _jumlahController.dispose();
    super.dispose();
  }

  // --- LOGIKA UTAMA SUBMIT ---
  void _submitBilling(BuildContext context, BillingController controller) {
    // 1. Validasi Form secara keseluruhan
    if (!_formKey.currentState!.validate()) {
      // Validator Field akan menampilkan error, tidak perlu SnackBar tambahan
      return;
    }
    
    // 2. Validasi ID Dropdown (Pastikan tidak null)
    final int? familyId = _selectedFamilyId;
    final int? duesTypeId = _selectedDuesTypeId;

    if (familyId == null || duesTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih Warga dan Kategori Iuran.')),
      );
      return;
    }
    
    // 3. Ambil data
    // Mengubah string jumlah (misal "50.000") menjadi double (50000.0)
    final String rawAmountText = _jumlahController.text.replaceAll('.', '');
    final double amountValue = double.tryParse(rawAmountText) ?? 0.0;
    
    // Pengecekan ekstra untuk amount (meskipun sudah ada di validator)
    if (amountValue <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jumlah iuran tidak valid.')),
      );
      return;
    }
    
    final periodString = DateFormat('MMMM yyyy', 'id_ID').format(_selectedDate);

    // 4. Buat Payload (Sekarang menggunakan variabel non-nullable)
    final payload = CreateBillingPayload(
      familyId: familyId,        // <-- Tidak ada lagi operator '!'
      duesTypeId: duesTypeId,    // <-- Tidak ada lagi operator '!'
      period: periodString,
      amount: amountValue,
    );

    // 5. Kirim ke Controller
    controller.createBilling(payload);
  }

  // --- LOGIKA TAMPILAN FEEDBACK (DIALOG) ---
  void _showFeedbackDialog(BuildContext context, BillingController controller) {
    if (controller.state == BillingState.success) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('✅ Sukses'),
          content: Text(controller.message ?? 'Tagihan berhasil dibuat.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                controller.resetState();
                _formKey.currentState?.reset(); // Opsional: Reset form
                _jumlahController.clear();
                setState(() {
                  _selectedFamilyId = null;
                  _selectedDuesTypeId = null;
                  _selectedDate = DateTime.now();
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else if (controller.state == BillingState.error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('❌ Gagal'),
          content: Text(controller.message ?? 'Gagal membuat tagihan. Silakan coba lagi.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                controller.resetState();
              },
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
    }
  }

  // --- LOGIKA UNTUK PEMILIHAN TANGGAL ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year - 2), // 2 tahun lalu
      lastDate: DateTime(DateTime.now().year + 2),  // 2 tahun kedepan
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // --- LOGIKA UNTUK UPDATE AMOUNT BERDASARKAN KATEGORI IURAN ---
  void _updateAmountByDuesType(int? duesTypeId) {
    final selectedDuesType = _dummyDuesTypes.firstWhere(
      (dt) => dt['id'] == duesTypeId,
      orElse: () => {'default_amount': 0.0},
    );
    final amount = selectedDuesType['default_amount'] as double;
    _jumlahController.text = NumberFormat('#,##0', 'id_ID').format(amount);
  }


  @override
  Widget build(BuildContext context) {
    // 1. Inisialisasi Controller
    return ChangeNotifierProvider<BillingController>(
      create: (_) => BillingController(BillingRepository(BillingService())),
      child: Consumer<BillingController>(
        builder: (context, controller, child) {
          // 2. Listener untuk memicu dialog setelah operasi selesai
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showFeedbackDialog(context, controller);
          });
          
          final bool isLoading = controller.state == BillingState.loading;

          return PageLayout(
            title: 'Tagih Iuran',
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // 1. Pilih Warga (Family ID)
                            DropdownButtonFormField<int>(
                              value: _selectedFamilyId,
                              decoration: const InputDecoration(
                                labelText: 'Pilih Warga (Kepala Keluarga)',
                                border: OutlineInputBorder(),
                              ),
                              items: _dummyFamilies.map((family) {
                                return DropdownMenuItem<int>(
                                  value: family['id'] as int,
                                  child: Text(family['name'] as String),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedFamilyId = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Pilih warga';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // 2. Pilih Kategori Iuran (Dues Type ID)
                            DropdownButtonFormField<int>(
                              value: _selectedDuesTypeId,
                              decoration: const InputDecoration(
                                labelText: 'Pilih Jenis/Kategori Iuran',
                                border: OutlineInputBorder(),
                              ),
                              items: _dummyDuesTypes.map((duesType) {
                                return DropdownMenuItem<int>(
                                  value: duesType['id'] as int,
                                  child: Text(duesType['name'] as String),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedDuesTypeId = value;
                                  _updateAmountByDuesType(value); // Update jumlah otomatis
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Pilih kategori iuran';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // 3. Input Jumlah Iuran
                            TextFormField(
                              controller: _jumlahController,
                              decoration: const InputDecoration(
                                labelText: 'Jumlah Iuran',
                                border: OutlineInputBorder(),
                                prefixText: 'Rp ',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                // Optional: Input formatter untuk Rupiah jika dibutuhkan
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty || (double.tryParse(value.replaceAll('.', '')) ?? 0.0) <= 0) {
                                  return 'Masukkan jumlah iuran yang valid';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // 4. Input Periode (Tanggal/Bulan)
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text('Periode: ${DateFormat('MMMM yyyy', 'id_ID').format(_selectedDate)}'),
                              trailing: const Icon(Icons.calendar_today),
                              onTap: () => _selectDate(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // 5. Tombol Submit
                    ElevatedButton(
                      onPressed: isLoading ? null : () => _submitBilling(context, controller),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text('Tagih Iuran'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}