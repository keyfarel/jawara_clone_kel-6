import 'dart:io';
import 'dart:typed_data'; // Tambah ini untuk Uint8List
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Tambah ini untuk kIsWeb
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Asumsi path import yang hilang (Harap pastikan path ini benar)
import '../../../../layouts/pages_layout.dart';
import '../../controllers/other_income_post_controller.dart'; 

// Model statis (pengganti TransactionCategoryModel)
class CategoryItem {
  final int id;
  final String name;
  CategoryItem(this.id, this.name);
}

// Daftar kategori statis dengan ID (HARUS DISESUAIKAN dengan ID di database Anda)
final List<CategoryItem> CategoryList = [
  CategoryItem(1, "Pendapatan Lainnya"),
  CategoryItem(2, "Donasi"),
  CategoryItem(3, "Lain-lain"),
];

class PemasukanLainTambahPage extends StatefulWidget {
  const PemasukanLainTambahPage({super.key});

  @override
  State<PemasukanLainTambahPage> createState() =>
      _PemasukanLainTambahPageState();
}

class _PemasukanLainTambahPageState extends State<PemasukanLainTambahPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _namaController = TextEditingController();
  final _nominalController = TextEditingController();
  final _deskripsiController = TextEditingController(); 

  // State Data
  CategoryItem? _selectedCategory; 
  DateTime? _tanggal = DateTime.now();
  File? _buktiImage;
  Uint8List? _buktiImageBytes; // State baru untuk Web/Image.memory

  final ImagePicker _picker = ImagePicker();

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
        // DI WEB: Baca file sebagai bytes untuk ditampilkan (Image.memory)
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _buktiImageBytes = bytes;
          // _buktiImage (File) masih diperlukan untuk API post
          // Meskipun objek File di Web tidak berfungsi untuk Image.file, 
          // path-nya mungkin digunakan oleh API service untuk identifikasi. 
          // Jika API Anda mengharapkan File, biarkan saja:
          _buktiImage = File(pickedFile.path); 
        });
      } else {
        // DI MOBILE/DESKTOP: Simpan sebagai File dan reset bytes
        setState(() {
          _buktiImage = File(pickedFile.path);
          _buktiImageBytes = null;
        });
      }
    }
  }

  void _submitForm() async {
    // ... (Logika submit tetap sama)
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih kategori dulu")),
      );
      return;
    }
    
    // Perhatikan: Validasi ini mungkin perlu disesuaikan jika di Web
    // karena _buktiImage adalah File dummy di Web. 
    // Jika Anda mewajibkan upload, cek apakah _buktiImage != null 
    // (yang dijamin setelah _pickImage) atau cek _buktiImageBytes di Web.
    if (_buktiImage == null && !kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan upload bukti pemasukan dulu")),
      );
      return;
    } 

    // Pastikan Controller sudah didaftarkan di MultiProvider di atas root widget
    final controller = Provider.of<OtherIncomePostController>(context, listen: false);

    // Ambil nilai-nilai
    final categoryId = _selectedCategory!.id;
    final title = _namaController.text;
    final amount = double.tryParse(_nominalController.text.replaceAll('.', '')) ?? 0.0;
    final transactionDate = _tanggal!;
    final description = _deskripsiController.text.isNotEmpty ? _deskripsiController.text : null;
    
    controller.resetState(); 
    
    try {
      await controller.postOtherIncome(
        categoryId: categoryId,
        title: title,
        amount: amount,
        transactionDate: transactionDate,
        description: description,
        // _buktiImage ini seharusnya adalah objek yang dapat dihandle oleh API Anda (File di mobile, XFile/bytes di Web)
        proofImage: _buktiImage, 
      );

      // 4. Handle Hasil
      if (controller.state == OtherIncomePostState.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Pemasukan ${title} berhasil ditambahkan!',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
        _resetForm();
        Navigator.of(context).pop(); 
      } else if (controller.state == OtherIncomePostState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.errorMessage ?? 'Gagal menambahkan pemasukan. Silakan coba lagi.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error jaringan: ${e.toString()}')),
      );
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
      _buktiImageBytes = null; // Reset bytes juga
    });
  }

  // ========================
  // WIDGET BUILD
  // ========================

  @override
  Widget build(BuildContext context) {
    return Consumer<OtherIncomePostController>(
      builder: (context, controller, child) {
        final isLoading = controller.state == OtherIncomePostState.loading;
        
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
                    
                    // Nama Pemasukan (Title)
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
                    
                    // Tanggal Pemasukan (Transaction Date)
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Tanggal Pemasukan",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: isLoading ? null : _pickDate,
                        ),
                        // Menggunakan DateFormat
                        hintText: _tanggal == null
                            ? "Pilih Tanggal"
                            : DateFormat('dd/MM/yyyy').format(_tanggal!),
                      ),
                      validator: (_) =>
                          _tanggal == null ? "Tanggal belum dipilih" : null,
                      controller: TextEditingController(
                        text: _tanggal == null ? '' : DateFormat('dd/MM/yyyy').format(_tanggal!),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Kategori Pemasukan (Category ID)
                    DropdownButtonFormField<CategoryItem>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: "Kategori Pemasukan",
                        border: OutlineInputBorder(),
                      ),
                      items: CategoryList 
                          .map((k) => DropdownMenuItem(value: k, child: Text(k.name)))
                          .toList(),
                      onChanged: isLoading ? null : (val) => setState(() => _selectedCategory = val),
                      validator: (val) =>
                          val == null ? "Pilih kategori dulu" : null,
                    ),
                    const SizedBox(height: 16),

                    // Nominal (Amount)
                    TextFormField(
                      controller: _nominalController,
                      keyboardType: TextInputType.number,
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        labelText: "Nominal",
                        prefixText: "Rp ",
                        hintText: "Masukkan jumlah nominal",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Nominal wajib diisi";
                        }
                        final n = double.tryParse(val.replaceAll('.', ''));
                        if (n == null || n <= 0) return "Nominal tidak valid";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Deskripsi (Description) - Field Opsional
                    TextFormField(
                      controller: _deskripsiController,
                      maxLines: 3,
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        labelText: "Deskripsi (Opsional)",
                        hintText: "Detail atau keterangan tambahan",
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Bukti Pemasukan (Proof Image)
                    const Text(
                      "Bukti Pemasukan",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: isLoading ? null : _pickImage,
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
                        child: _buildImagePreview(), // Gunakan fungsi kondisional baru
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
                            onPressed: isLoading ? null : _submitForm,
                            child: isLoading 
                                ? const SizedBox(
                                    height: 20, 
                                    width: 20, 
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                  )
                                : const Text(
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

  // Fungsi baru untuk menampilkan pratinjau gambar (Multi-platform)
  Widget _buildImagePreview() {
    if (_buktiImage == null && _buktiImageBytes == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.cloud_upload, size: 40, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            "Upload bukti pemasukan (.png / .jpg)",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      );
    }

    Widget imageWidget;
    
    if (kIsWeb) {
      // WEB: Gunakan Image.memory() dengan bytes
      if (_buktiImageBytes != null) {
        imageWidget = Image.memory(
          _buktiImageBytes!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      } else {
        // Fallback jika Web tetapi bytes-nya null
        imageWidget = const Center(child: Text('Gagal memuat pratinjau Web.'));
      }
    } else {
      // MOBILE/DESKTOP: Gunakan Image.file()
      imageWidget = Image.file(
        _buktiImage!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: imageWidget,
    );
  }
}