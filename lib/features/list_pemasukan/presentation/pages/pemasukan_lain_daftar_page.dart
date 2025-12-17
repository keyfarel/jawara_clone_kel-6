import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/layouts/pages_layout.dart';

// Import komponen API
import '../../controllers/other_income_list_controller.dart';
import '../../data/models/other_income_list_model.dart';
import '../../data/repository/other_income_list_repository.dart';
import '../../data/services/other_income_list_service.dart';

class PemasukanLainDaftarPage extends StatefulWidget {
  const PemasukanLainDaftarPage({super.key});

  @override
  State<PemasukanLainDaftarPage> createState() =>
      _PemasukanLainDaftarPageState();
}

class _PemasukanLainDaftarPageState extends State<PemasukanLainDaftarPage> {
  // Variabel token hardcode dihapus.

  // Filter State (tetap di sini karena filter belum terintegrasi ke Controller)
  String? selectedKategori;
  DateTime? dariTanggal;
  DateTime? sampaiTanggal;
  TextEditingController cariNamaController = TextEditingController();

  // Helper untuk format mata uang
  final NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    // 1. Setup Provider untuk Controller API
    return ChangeNotifierProvider<OtherIncomeListController>(
      create: (_) {
        // Inisialisasi Service TANPA TOKEN, karena Service sekarang mengambil dari SharedPreferences.
        final service = OtherIncomeListService();
        final repo = OtherIncomeRepositoryImpl(service);
        final controller = OtherIncomeListController(repo);

        // Panggil API saat pertama kali dibuat
        controller.fetchOtherIncomes();

        return controller;
      },
      // 2. Gunakan Consumer untuk membaca state
      child: Consumer<OtherIncomeListController>(
        builder: (context, controller, child) {
          final isLoading = controller.state == OtherIncomeListState.loading;
          final isError = controller.state == OtherIncomeListState.error;
          final incomes = controller.otherIncomes;

          return PageLayout(
            title: 'Pemasukan Lain - Daftar',
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                // Memastikan refresh tidak bisa dipanggil saat sedang loading
                onPressed: isLoading ? null : () => controller.fetchOtherIncomes(),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  // TODO: Navigasi ke Tambah Pemasukan
                },
              ),
            ],
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Tombol filter
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      icon: const Icon(Icons.filter_list, color: Colors.white),
                      label: const Text(
                        "Filter",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => _showFilterDialog(context),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tampilkan indikator loading saat memuat
                  if (isLoading && incomes.isEmpty)
                    const Expanded(child: Center(child: CircularProgressIndicator())),

                  // Tampilkan error
                  if (isError)
                    Expanded(
                      child: Center(
                        child: Text(
                          "Gagal memuat: ${controller.errorMessage}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),

                  // Tampilkan data kosong
                  if (incomes.isEmpty && !isLoading && !isError)
                    const Expanded(
                      child: Center(
                        child: Text("Tidak ada data pemasukan ditemukan."),
                      ),
                    ),

                  // ===== Daftar data dari API =====
                  if (incomes.isNotEmpty)
                    Expanded(
                      child: ListView.separated(
                        itemCount: incomes.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = incomes[index];
                          final nominalText = currencyFormatter.format(item.amount);

                          return InkWell(
                            onTap: () => _showDetail(context, item),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header nama (title) dan nominal
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        // Menggunakan title dari API
                                        child: Text(
                                          item.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        nominalText,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  // Kategori dan tanggal
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Menggunakan category.name dari API
                                      Text(
                                        item.category.name,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          // Menggunakan transactionDate dari API
                                          Text(
                                            DateFormat('dd MMMM yyyy').format(item.transactionDate),
                                            style: TextStyle(color: Colors.grey[700]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ======================
  // DETAIL MODAL (Tidak ada perubahan)
  // ======================
  void _showDetail(BuildContext context, OtherIncomeItemModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 5,
                    width: 50,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const Text(
                  "Detail Pemasukan Lain",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),

                // Menggunakan field dari OtherIncomeItemModel
                _detailItem("ID Transaksi", item.id.toString()),
                _detailItem("Nama Pemasukan", item.title),
                _detailItem("Kategori", item.category.name),
                _detailItem("Tanggal Transaksi", DateFormat('dd MMMM yyyy').format(item.transactionDate)),
                _detailItem("Deskripsi", item.description ?? 'Tidak Ada Deskripsi'),
                _detailItem(
                  "Jumlah",
                  currencyFormatter.format(item.amount),
                  color: Colors.green,
                ),
                // Data Verifikasi belum ada di API response, kita skip
                // _detailItem("Tanggal Terverifikasi", item.tanggalVerifikasi),
                // _detailItem("Verifikator", item.verifikator),

                // Tambahan: Link Bukti (jika ada)
                if (item.proofImageLink != null)
                  _detailItem("Bukti Transaksi", "Lihat Gambar", color: Colors.blue),

                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text("Tutup"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailItem(String title, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: color ?? Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ======================
  // FILTER DIALOG (Tidak ada perubahan yang diperlukan pada fungsi ini)
  // ======================
  void _showFilterDialog(BuildContext context) {
    // Anda dapat mengambil controller di sini jika ingin menerapkan filter.
    final controller = Provider.of<OtherIncomeListController>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filter Pemasukan Non Iuran"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: cariNamaController,
                  decoration: const InputDecoration(
                    labelText: "Nama",
                    hintText: "Cari nama...",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                // Anda harus mendapatkan daftar kategori dari API nanti, saat ini menggunakan mock
                DropdownButtonFormField<String>(
                  value: selectedKategori,
                  decoration: const InputDecoration(
                    labelText: "Kategori",
                    border: OutlineInputBorder(),
                  ),
                  items: ["Pendapatan Lainnya", "Donasi", "Lain-lain"]
                      .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedKategori = val),
                ),
                const SizedBox(height: 12),
                _datePickerField("Dari Tanggal", dariTanggal, (picked) {
                  setState(() => dariTanggal = picked);
                }),
                const SizedBox(height: 12),
                _datePickerField("Sampai Tanggal", sampaiTanggal, (picked) {
                  setState(() => sampaiTanggal = picked);
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  cariNamaController.clear();
                  selectedKategori = null;
                  dariTanggal = null;
                  sampaiTanggal = null;
                });
                Navigator.pop(context);

                // Panggil API tanpa filter (Default)
                controller.fetchOtherIncomes();
              },
              child: const Text("Reset Filter"),
            ),
            ElevatedButton(
              onPressed: () {
                // Logika penerapan filter:
                // Di sini Anda akan memanggil controller.fetchOtherIncomes()
                // dengan menyertakan parameter dari state filter (cariNamaController.text, selectedKategori, dll.)
                Navigator.pop(context);
                // TODO: Panggil API dengan parameter filter yang baru
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
              ),
              child: const Text("Terapkan"),
            ),
          ],
        );
      },
    );
  }

  Widget _datePickerField(
    String label,
    DateTime? date,
    Function(DateTime?) onPicked,
  ) {
    // Mengubah onPicked agar menerima DateTime? untuk reset
    return TextFormField(
      readOnly: true,
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) onPicked(picked);
      },
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (date != null && date.year != 0)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => onPicked(null)), // Reset
              ),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: date ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) onPicked(picked);
              },
            ),
          ],
        ),
        hintText: date == null ? "--/--/----" : DateFormat('dd/MM/yyyy').format(date),
      ),
    );
  }
}