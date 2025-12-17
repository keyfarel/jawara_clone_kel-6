import 'dart:io';
import 'dart:typed_data'; // Untuk Uint8List
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../widgets/layouts/pages_layout.dart';
import '../../controllers/other_expense_controller.dart';
import '../../../shared/controllers/transaction_category_controller.dart';

class TambahPage extends StatefulWidget {
  const TambahPage({super.key});

  @override
  State<TambahPage> createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  final _namaController = TextEditingController();
  final _nominalController = TextEditingController();
  final _keteranganController = TextEditingController();
  
  DateTime? _selectedDate;
  int? _selectedCategoryId;
  
  // State untuk gambar
  File? _imageFile; 
  Uint8List? _webImage;

  @override
  void initState() {
    super.initState();
    // Memuat kategori saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionCategoryController>().loadCategories();
    });
  }

  /// Fungsi untuk mengambil gambar dari galeri
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery, 
      imageQuality: 80,
    );
    
    if (pickedFile != null) {
      if (kIsWeb) {
        // Baca bytes untuk tampilan di Web agar tidak error !kIsWeb
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
          // Di web, File(path) tidak bisa dirender, jadi kita simpan path-nya saja
          _imageFile = File(pickedFile.path); 
        });
      } else {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    }
  }

  void _submit() async {
    // 1. Validasi Input Dasar
    if (_namaController.text.isEmpty || 
        _selectedCategoryId == null || 
        _nominalController.text.isEmpty || 
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon lengkapi data yang wajib diisi (*)")),
      );
      return;
    }

    // 2. Panggil Controller (Parameter 'image' sudah didefinisikan di controller)
    await context.read<OtherExpenseController>().addExpense(
          categoryId: _selectedCategoryId!,
          title: _namaController.text,
          amount: _nominalController.text,
          date: _selectedDate!,
          description: _keteranganController.text,
          image: _imageFile, 
        );

    // 3. Cek State Hasil Akhir
    if (!mounted) return;
    final state = context.read<OtherExpenseController>().state;
    final msg = context.read<OtherExpenseController>().message;

    if (state == ExpenseState.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg ?? "Pengeluaran berhasil disimpan!")),
      );
      Navigator.pop(context); // Kembali ke list
    } else if (state == ExpenseState.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: $msg"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Tambah Pengeluaran',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Kategori Pengeluaran *"),
            Consumer<TransactionCategoryController>(
              builder: (context, catCtrl, child) {
                final listKategoriExpense = catCtrl.expenseCategories;
                return DropdownButtonFormField<int>(
                  value: _selectedCategoryId,
                  isExpanded: true,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  hint: Text(catCtrl.isLoading ? "Memuat..." : "-- Pilih Kategori --"),
                  items: listKategoriExpense.map((cat) {
                    return DropdownMenuItem(value: cat.id, child: Text(cat.name));
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedCategoryId = val),
                );
              },
            ),
            const SizedBox(height: 16),

            _buildLabel("Nama Pengeluaran *"),
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                hintText: "Contoh: Beli IOT KIT",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            _buildLabel("Tanggal *"),
            TextField(
              readOnly: true,
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
              decoration: InputDecoration(
                hintText: _selectedDate == null 
                    ? "Pilih Tanggal" 
                    : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 16),

            _buildLabel("Nominal *"),
            TextField(
              controller: _nominalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixText: "Rp ",
              ),
            ),
            const SizedBox(height: 16),

            _buildLabel("Keterangan"),
            TextField(
              controller: _keteranganController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Contoh: Pembelian komponen untuk skripsi",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            _buildLabel("Bukti Gambar (Opsional)"),
            InkWell(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[350]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),
                child: _imageFile == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_outlined, color: Colors.grey[400], size: 40),
                          const SizedBox(height: 8),
                          Text("Klik untuk upload bukti", style: TextStyle(color: Colors.grey[600])),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: kIsWeb 
                          ? Image.memory(_webImage!, fit: BoxFit.cover)
                          : Image.file(_imageFile!, fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 32),

            Consumer<OtherExpenseController>(
              builder: (context, ctrl, child) {
                bool isLoading = ctrl.state == ExpenseState.loading;
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue[800],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text("Simpan Pengeluaran", 
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }
}