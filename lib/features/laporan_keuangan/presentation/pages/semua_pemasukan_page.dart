import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../layouts/pages_layout.dart';
import '../../controllers/other_income_controller.dart';

class SemuaPemasukanPage extends StatefulWidget {
  const SemuaPemasukanPage({super.key});

  @override
  State<SemuaPemasukanPage> createState() => _SemuaPemasukanPageState();
}

class _SemuaPemasukanPageState extends State<SemuaPemasukanPage> {
  // Controller untuk text field agar teks tanggal muncul
  final TextEditingController _startCtrl = TextEditingController();
  final TextEditingController _endCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load data saat halaman pertama kali dibuka.
    // Panggil TANPA 'force: true', agar controller menggunakan data cache (jika ada).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OtherIncomeController>().loadIncomes();
    });
  }

  @override
  void dispose() {
    _startCtrl.dispose();
    _endCtrl.dispose();
    super.dispose();
  }

  // Helper Format Rupiah
  String _formatRupiah(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  // Helper Format Tanggal Tampilan (dd/MM/yyyy)
  String _formatDateDisplay(String dateApi) {
    try {
      DateTime date = DateTime.parse(dateApi);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateApi;
    }
  }

  // Fungsi Pilih Tanggal
  Future<void> _pickDate(bool isStart) async {
    final controller = context.read<OtherIncomeController>();
    final initialDate = isStart
        ? (controller.startDate ?? DateTime.now())
        : (controller.endDate ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      if (isStart) {
        _startCtrl.text = DateFormat('dd/MM/yyyy').format(picked);
        controller.setDateFilter(picked, controller.endDate);
      } else {
        _endCtrl.text = DateFormat('dd/MM/yyyy').format(picked);
        controller.setDateFilter(controller.startDate, picked);
      }
    }
  }

  // --- LOGIC REFRESH (TARIK KE BAWAH) ---
  Future<void> _handleRefresh() async {
    // Disini kita PAKSA ambil data baru dari API (abaikan cache)
    await context.read<OtherIncomeController>().loadIncomes(force: true);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OtherIncomeController>();

    return PageLayout(
      title: 'Semua Pemasukan',
      body: Column(
        children: [
          // --- Filter Section ---
          Card(
            margin: const EdgeInsets.all(16.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _startCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Dari Tanggal',
                            suffixIcon: Icon(Icons.calendar_today, size: 20),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          readOnly: true,
                          onTap: () => _pickDate(true),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _endCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Sampai Tanggal',
                            suffixIcon: Icon(Icons.calendar_today, size: 20),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          readOnly: true,
                          onTap: () => _pickDate(false),
                        ),
                      ),
                    ],
                  ),
                  // Tombol Reset Filter jika filter aktif
                  if (controller.startDate != null ||
                      controller.endDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            _startCtrl.clear();
                            _endCtrl.clear();
                            controller.resetFilter();
                          },
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text("Reset Filter"),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // --- List Pemasukan dengan RefreshIndicator ---
          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _handleRefresh,
                              child: const Text("Coba Lagi"),
                            )
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        // 1. Tambahkan Widget RefreshIndicator
                        onRefresh: _handleRefresh,
                        color: Colors.blue,
                        backgroundColor: Colors.white,
                        child: controller.incomes.isEmpty
                            // 2. Gunakan ListView walaupun kosong agar bisa di-swipe refresh
                            ? ListView(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.inbox, size: 50, color: Colors.grey),
                                          SizedBox(height: 10),
                                          Text("Belum ada data pemasukan"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                itemCount: controller.incomes.length,
                                padding: const EdgeInsets.only(bottom: 20),
                                itemBuilder: (context, index) {
                                  final income = controller.incomes[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 6.0,
                                    ),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      leading: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: const Icon(
                                          Icons.arrow_downward,
                                          color: Colors.green,
                                        ),
                                      ),
                                      title: Text(
                                        income.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 4),
                                          Text(
                                            income.categoryName,
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            _formatRupiah(income.amount),
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            _formatDateDisplay(income.date),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          if (income.proofImageLink != null)
                                            const Icon(
                                              Icons.image,
                                              size: 16,
                                              color: Colors.blueGrey,
                                            ),
                                        ],
                                      ),
                                      onTap: () {
                                        // Navigate to detail page if needed
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
          ),
        ],
      ),
    );
  }
}