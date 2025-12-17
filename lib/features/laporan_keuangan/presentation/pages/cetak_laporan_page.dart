import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../utils/pdf_generator.dart';
import '../../../../widgets/layouts/pages_layout.dart';
import '../../controllers/laporan_controller.dart';
import '../../data/models/finance_report_model.dart';

class CetakLaporanPage extends StatefulWidget {
  const CetakLaporanPage({super.key});

  @override
  State<CetakLaporanPage> createState() => _CetakLaporanPageState();
}

class _CetakLaporanPageState extends State<CetakLaporanPage> {
  // Controllers
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  // State variables
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedType = 'all'; // Default 'all' sesuai API

  // Helper untuk format tanggal kirim ke API (YYYY-MM-DD)
  String _formatDateApi(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  // Helper untuk display (dd/MM/yyyy)
  String _formatDateDisplay(DateTime date) =>
      DateFormat('dd/MM/yyyy').format(date);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LaporanController>();
    final isLoading = controller.isLoading;

    return PageLayout(
      title: 'Cetak Laporan',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter Laporan Keuangan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  // Tanggal Mulai
                  const Text(
                    'Tanggal Mulai',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _startDateController,
                    readOnly: true,
                    onTap: () => _pickDate(true),
                    decoration: InputDecoration(
                      hintText: 'Pilih Tanggal',
                      suffixIcon: const Icon(Icons.calendar_today_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tanggal Akhir
                  const Text(
                    'Tanggal Akhir',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _endDateController,
                    readOnly: true,
                    onTap: () => _pickDate(false),
                    decoration: InputDecoration(
                      hintText: 'Pilih Tanggal',
                      suffixIcon: const Icon(Icons.calendar_today_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Jenis Laporan
                  const Text(
                    'Jenis Laporan',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedType, // Pastikan default variable ini 'all'
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    // VALUE HARUS BAHASA INGGRIS KECIL (sesuai database/enum)
                    items: const [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('Semua Transaksi'),
                      ),
                      DropdownMenuItem(
                        value: 'income',
                        child: Text('Pemasukan'),
                      ),
                      DropdownMenuItem(
                        value: 'expense',
                        child: Text('Pengeluaran'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Tombol Aksi
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _generateReport,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Buat Laporan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: _resetForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
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
      ),
    );
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          _startDateController.text = _formatDateDisplay(picked);
        } else {
          _endDate = picked;
          _endDateController.text = _formatDateDisplay(picked);
        }
      });
    }
  }

  void _resetForm() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _startDateController.clear();
      _endDateController.clear();
      _selectedType = 'all';
    });
  }

  void _generateReport() async {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap pilih tanggal mulai dan akhir'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final controller = context.read<LaporanController>();

    final success = await controller.generateReport(
      startDate: _formatDateApi(_startDate!),
      endDate: _formatDateApi(_endDate!),
      type: _selectedType,
    );

    if (!mounted) return;

    if (success && controller.reportResult != null) {
      // --- PERUBAHAN DISINI ---
      // Panggil PDF Generator
      await PdfGenerator.generateAndShow(controller.reportResult!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.errorMessage ?? 'Gagal mengambil data'),
        ),
      );
    }
  }

  void _showResultDialog(FinanceReportModel report) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Laporan Siap"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Periode: ${report.meta.period}"),
            const Divider(),
            Text("Total Masuk: Rp ${report.meta.totalIncome}"),
            Text("Total Keluar: Rp ${report.meta.totalExpense}"),
            Text("Saldo: Rp ${report.meta.netBalance}"),
            const SizedBox(height: 10),
            Text("Jumlah Transaksi: ${report.data.length}"),
            const SizedBox(height: 20),
            const Text(
              "Catatan: Fitur download PDF akan segera hadir. Data JSON berhasil diambil.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }
}
