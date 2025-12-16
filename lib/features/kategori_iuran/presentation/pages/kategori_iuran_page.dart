import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <-- Import Provider
import 'package:intl/intl.dart'; // <-- Perlu untuk format Rupiah/Mata Uang 
import '../../../../layouts/pages_layout.dart';

// Import Dues Type components
import '../../controllers/dues_type_controller.dart';
import '../../data/models/dues_type_model.dart';
import '../../data/repository/dues_type_repository.dart';
import '../../data/services/dues_type_service.dart';

// Fungsi Builder untuk TextFormField yang lebih mudah digunakan (diperbaiki)
typedef FormFieldBuilder<T> = Widget Function(FormFieldState<T> state);

class KategoriIuranPage extends StatelessWidget {
  const KategoriIuranPage({super.key});

  // Helper untuk memformat mata uang (misal: Rp 25.000,00)
  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID', // Lokasi Indonesia
      symbol: 'Rp ',
      decimalDigits: 0, // Opsional: menghilangkan desimal jika selalu nol
    );
    return formatter.format(amount);
  }

  // Helper untuk membangun TextFormField
  Widget _buildTextFormField(String label, String hint) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Field ini tidak boleh kosong';
        }
        return null;
      },
    );
  }

  // Helper untuk baris data di tabel
  TableRow _buildRow(int no, DuesTypeModel duesType) {
    final Color rowColor = no % 2 == 0 ? Colors.white : const Color(0xFFFAFAFA);

    return TableRow(
      decoration: BoxDecoration(color: rowColor),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Text(no.toString()),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                duesType.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              // Menampilkan Jumlah Iuran
              Text(
                _formatCurrency(duesType.amount),
                style: const TextStyle(color: Colors.green, fontSize: 13),
              ),
            ],
          ),
        ),
        // Kolom Aksi (Edit/Hapus)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                onPressed: () {
                  // TODO: Implementasi Edit
                  debugPrint('Edit ${duesType.name}');
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                onPressed: () {
                  // TODO: Implementasi Delete
                  debugPrint('Delete ${duesType.name}');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Inisialisasi Controller menggunakan ChangeNotifierProvider
    return ChangeNotifierProvider(
      create: (_) {
        final service = DuesTypeService();
        final repository = DuesTypeRepository(service); 
        final controller = DuesTypeController(repository);
        // Memuat data saat controller dibuat
        controller.fetchListDuesTypes(); 
        return controller;
      },
      // 2. Menggunakan Consumer untuk mendengarkan perubahan state
      child: Consumer<DuesTypeController>(
        builder: (context, controller, child) {
          return PageLayout(
            title: 'Kategori Iuran', // title harus berupa Widget
            actions: [
              if (controller.state == DuesTypeState.error)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: controller.fetchListDuesTypes,
                ),
            ],
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================== Info Box ==================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F1FF),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFB7D3FF)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Info:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E63D0),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Jenis Iuran: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                  text:
                                      'Saat ini, hanya menampilkan semua kategori iuran (Bulanan/Khusus) yang terdaftar.\n'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ================== Konten Utama (Loading/Error/Data) ==================
                  _buildContentBasedOnState(context, controller),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget pembantu untuk menangani state
  Widget _buildContentBasedOnState(BuildContext context, DuesTypeController controller) {
    if (controller.state == DuesTypeState.loading || controller.state == DuesTypeState.initial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.state == DuesTypeState.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 8),
              Text(
                'Gagal memuat data:\n${controller.errorMessage ?? "Unknown Error"}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: controller.fetchListDuesTypes,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }
    
    // State Loaded
    final List<DuesTypeModel> duesList = controller.listDuesTypes;

    if (duesList.isEmpty) {
      return const Center(
        child: Text("Tidak ada data kategori iuran yang ditemukan."),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(40), // NO
          1: FlexColumnWidth(2),    // NAMA & AMOUNT
          2: FlexColumnWidth(1.2),  // AKSI (Edit/Delete)
        },
        border: TableBorder.symmetric(
          inside: BorderSide(color: Colors.grey.shade300),
        ),
        children: [
          // Header tabel
          const TableRow(
            decoration: BoxDecoration(color: Color(0xFFF7F7F7)),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Text('NO', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Text('KATEGORI & JUMLAH', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Text('AKSI', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          // Data dinamis dari controller
          ...duesList.asMap().entries.map((entry) {
            int index = entry.key;
            DuesTypeModel duesType = entry.value;
            return _buildRow(index + 1, duesType);
          }).toList(),
        ],
      ),
    );
  }
}