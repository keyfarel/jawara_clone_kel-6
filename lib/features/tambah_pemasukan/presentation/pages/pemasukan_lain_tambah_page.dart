import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Import Layout & Controllers
import '../../../../layouts/pages_layout.dart';
import '../../controllers/other_income_post_controller.dart';
import '../../../shared/controllers/transaction_category_controller.dart';
import '../../../shared/data/models/transaction_category_model.dart';

class PemasukanLainTambahPage extends StatefulWidget {
  const PemasukanLainTambahPage({super.key});

  @override
  State<PemasukanLainTambahPage> createState() => _PemasukanLainTambahPageState();
}

class _PemasukanLainTambahPageState extends State<PemasukanLainTambahPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _namaController = TextEditingController();
  final _nominalController = TextEditingController();
  final _deskripsiController = TextEditingController();

  // State Data
  TransactionCategory? _selectedCategory; // Tipe data dari model asli
  DateTime? _tanggal = DateTime.now();
  File? _buktiImage;
  Uint8List? _buktiImageBytes;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Memuat kategori dari API segera setelah halaman dirender
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionCategoryController>().loadCategories();
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nominalController.dispose();
    _deskripsiController.dispose();
    super.dispose();
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
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _buktiImageBytes = bytes;
          _buktiImage = File(pickedFile.path); 
        });
      } else {
        setState(() {
          _buktiImage = File(pickedFile.path);
          _buktiImageBytes = null;
        });
      }
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      _showSnackBar("Silakan pilih kategori dulu", Colors.orange);
      return;
    }

    if (_buktiImage == null && !kIsWeb) {
      _showSnackBar("Silakan upload bukti pemasukan dulu", Colors.orange);
      return;
    }

    final postController = Provider.of<OtherIncomePostController>(context, listen: false);

    // Data Parsing
    final int categoryId = _selectedCategory!.id;
    final String title = _namaController.text;
    final double amount = double.tryParse(_nominalController.text.replaceAll('.', '')) ?? 0.0;
    final DateTime transactionDate = _tanggal!;
    final String? description = _deskripsiController.text.isNotEmpty ? _deskripsiController.text : null;

    postController.resetState();

    try {
      await postController.postOtherIncome(
        categoryId: categoryId,
        title: title,
        amount: amount,
        transactionDate: transactionDate,
        description: description,
        proofImage: _buktiImage,
      );

      if (postController.state == OtherIncomePostState.success) {
        _showSnackBar('Pemasukan $title berhasil ditambahkan!', Colors.green);
        _resetForm();
        if (mounted) Navigator.of(context).pop();
      } else if (postController.state == OtherIncomePostState.error) {
        _showSnackBar(postController.errorMessage ?? 'Gagal menambahkan data.', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Terjadi kesalahan: ${e.toString()}', Colors.red);
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _namaController.clear();
    _nominalController.clear();
    _deskripsiController.clear();
    setState(() {
      _selectedCategory = null;
      _tanggal = DateTime.now();
      _buktiImage = null;
      _buktiImageBytes = null;
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  // ========================
  // WIDGET BUILD
  // ========================

  @override
  Widget build(BuildContext context) {
    return Consumer<OtherIncomePostController>(
      builder: (context, postCtrl, child) {
        final isLoading = postCtrl.state == OtherIncomePostState.loading;

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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    // Nama Pemasukan
                    TextFormField(
                      controller: _namaController,
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        labelText: "Nama Pemasukan",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty ? "Nama wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),

                    // Tanggal
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Tanggal Pemasukan",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: isLoading ? null : _pickDate,
                        ),
                      ),
                      controller: TextEditingController(
                        text: DateFormat('dd/MM/yyyy').format(_tanggal!),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Kategori (Dinamis dari API)
                    Consumer<TransactionCategoryController>(
                      builder: (context, catCtrl, child) {
                        // AMBIL HANYA KATEGORI INCOME
                        final categories = catCtrl.incomeCategories;

                        return DropdownButtonFormField<TransactionCategory>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: "Kategori Pemasukan",
                            hintText: catCtrl.isLoading ? "Memuat..." : "Pilih Kategori",
                            border: const OutlineInputBorder(),
                          ),
                          items: categories.map((cat) {
                            return DropdownMenuItem(
                              value: cat, 
                              child: Text(cat.name)
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedCategory = val),
                          validator: (val) => val == null ? "Pilih kategori" : null,
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Nominal
                    TextFormField(
                      controller: _nominalController,
                      keyboardType: TextInputType.number,
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        labelText: "Nominal",
                        prefixText: "Rp ",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) return "Nominal wajib diisi";
                        final n = double.tryParse(val.replaceAll('.', ''));
                        if (n == null || n <= 0) return "Nominal tidak valid";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Deskripsi
                    TextFormField(
                      controller: _deskripsiController,
                      maxLines: 3,
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        labelText: "Deskripsi (Opsional)",
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Bukti Pratinjau
                    const Text("Bukti Pemasukan", style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: isLoading ? null : _pickImage,
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _buildImagePreview(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: isLoading ? null : _submitForm,
                            child: isLoading 
                                ? const CircularProgressIndicator(color: Colors.white) 
                                : const Text("Submit", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                            onPressed: isLoading ? null : _resetForm,
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
      },
    );
  }

  Widget _buildImagePreview() {
    if (_buktiImage == null && _buktiImageBytes == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload, size: 40, color: Colors.grey),
            Text("Upload bukti (.png / .jpg)", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: kIsWeb
          ? (_buktiImageBytes != null 
              ? Image.memory(_buktiImageBytes!, fit: BoxFit.cover, width: double.infinity) 
              : const SizedBox())
          : Image.file(_buktiImage!, fit: BoxFit.cover, width: double.infinity),
    );
  }
}