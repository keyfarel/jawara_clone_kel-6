import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Untuk format mata uang & tanggal
import '../../../../layouts/pages_layout.dart';
import '../../controllers/other_expense_list_controller.dart';
import '../../data/models/other_expense_list_model.dart'; // Import model list API

class PengeluaranDaftarPage extends StatefulWidget {
  const PengeluaranDaftarPage({super.key});

  @override
  State<PengeluaranDaftarPage> createState() => _PengeluaranDaftarPageState();
}

class _PengeluaranDaftarPageState extends State<PengeluaranDaftarPage> {
  String? selectedJenis;

  @override
  void initState() {
    super.initState();
    // Panggil API saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OtherExpenseListController>().loadExpenses();
    });
  }

  // Fungsi Helper untuk Format Rupiah
  String formatRupiah(String amount) {
    final number = double.tryParse(amount) ?? 0;
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(number);
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: "Pengeluaran - Daftar",
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_alt),
          onPressed: () => _showFilterDialog(context),
        ),
      ],
      body: Consumer<OtherExpenseListController>(
        builder: (context, ctrl, child) {
          // 1. Tampilan Loading
          if (ctrl.state == ExpenseState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Tampilan Error
          if (ctrl.state == ExpenseState.error) {
            return Center(child: Text("Gagal memuat data: ${ctrl.message}"));
          }

          // 3. Filter Data
          final List<ExpenseListItem> filteredList = selectedJenis == null
              ? ctrl.expenseList
              : ctrl.expenseList.where((p) => p.category?.name == selectedJenis).toList();

          // 4. Tampilan Kosong
          if (filteredList.isEmpty) {
            return const Center(child: Text("Belum ada data pengeluaran."));
          }

          return RefreshIndicator(
            onRefresh: () => ctrl.loadExpenses(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final item = filteredList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                          child: Center(
                            child: Text("${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 10,
                                runSpacing: 8,
                                children: [
                                  _infoChip(
                                    item.category?.name ?? "Tanpa Kategori",
                                    Colors.blue[50]!,
                                    Colors.blue[800]!,
                                  ),
                                  _infoText("Tgl", item.transactionDate),
                                  _infoText("Nominal", formatRupiah(item.amount)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final ctrl = context.read<OtherExpenseListController>();
    // Ambil daftar kategori unik dari data yang ada
    final jenisList = ctrl.expenseList.map((p) => p.category?.name ?? "Tanpa Kategori").toSet().toList();

    showDialog(
      context: context,
      builder: (context) {
        String? tempJenis = selectedJenis;
        return AlertDialog(
          title: const Text("Filter Kategori"),
          content: DropdownButtonFormField<String>(
            value: tempJenis,
            items: jenisList.map((j) => DropdownMenuItem(value: j, child: Text(j))).toList(),
            onChanged: (val) => tempJenis = val,
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Pilih Kategori"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() => selectedJenis = null);
                Navigator.pop(context);
              },
              child: const Text("Reset"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => selectedJenis = tempJenis);
                Navigator.pop(context);
              },
              child: const Text("Terapkan"),
            ),
          ],
        );
      },
    );
  }

  Widget _infoChip(String value, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
      child: Text(value, style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 12)),
    );
  }

  Widget _infoText(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Text(value, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}