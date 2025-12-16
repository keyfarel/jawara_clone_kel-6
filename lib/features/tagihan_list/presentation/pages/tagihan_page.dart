import 'package:flutter/material.dart';
import 'package:myapp/layouts/pages_layout.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Import Controllers, Models, Repository, dan Service
import '../../controllers/billing_list_controller.dart';
import '../../data/models/billing_list_model.dart';
import '../../data/repository/billing_list_repository.dart';
import '../../data/services/billing_list_service.dart';

// Hapus model dummy 'Tagihan' dan import yang tidak terpakai

class TagihanDaftarPage extends StatefulWidget {
  const TagihanDaftarPage({super.key});

  @override
  State<TagihanDaftarPage> createState() => _TagihanDaftarPageState();
}

class _TagihanDaftarPageState extends State<TagihanDaftarPage> {
  // State Filter dan Paginasi
  String? _selectedStatusFilter; // Nama variabel diubah agar lebih spesifik
  int _currentPage = 1; // Nama variabel diubah
  // itemsPerPage dihapus karena paginasi diatur oleh API (default 10)

  // Inisialisasi API Call
  @override
  void initState() {
    super.initState();
  }
  
  // Fungsi untuk memicu pengambilan data
  void _fetchData(BillingListController controller, int page) {
    setState(() {
      _currentPage = page;
    });
    // TODO: Tambahkan logic untuk filter status di API jika endpoint mendukung
    controller.fetchBillings(page: page); 
  }

  // Logika Filter Dialog (Dipertahankan untuk demonstrasi filter lokal/status)
  void _showFilterDialog(BuildContext context, BillingListController controller) {
    String? tempStatus = _selectedStatusFilter;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filter Tagihan"),
          content: DropdownButtonFormField<String>(
            value: tempStatus,
            items: const ["unpaid", "paid"] // Menggunakan nilai status API (unpaid/paid)
                .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.toUpperCase()),
                    ))
                .toList(),
            onChanged: (val) => tempStatus = val,
            decoration: const InputDecoration(
              labelText: "Pilih Status Tagihan",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() => _selectedStatusFilter = null);
                _fetchData(controller, 1); // Fetch data baru setelah reset
                Navigator.pop(context);
              },
              child: const Text("Reset"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              onPressed: () {
                setState(() {
                  _selectedStatusFilter = tempStatus;
                  // Untuk saat ini, karena API tidak mendukung filter, kita filter di UI.
                  // Seharusnya, jika API support: _fetchData(controller, 1, status: tempStatus);
                  _currentPage = 1;
                });
                Navigator.pop(context);
              },
              child: const Text("Terapkan"),
            ),
          ],
        );
      },
    );
  }

  // Helper untuk Table Row (Tidak Berubah)
  TableRow _buildTableRow(String label, String value, [Color? accent]) {
    // ... (Logika _buildTableRow tetap sama) ...
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Text(":", textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: accent ?? Colors.black87,
              fontWeight: accent != null ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BillingListController>(
      create: (_) {
        final billingListService = BillingListService(); 
        final billingListRepo = BillingListRepositoryImpl(billingListService);
        
        final controller = BillingListController(billingListRepo);

        controller.fetchBillings(page: _currentPage);        
        return controller;
      },
      child: Consumer<BillingListController>(
        builder: (context, controller, child) {
          
          final bool isLoading = controller.state == BillingListState.loading;
          final bool isError = controller.state == BillingListState.error;
          final listResponse = controller.listResponse;
          
          // 2. Terapkan Filter Lokal (Karena API belum support filter status)
          List<BillingListItemModel> filteredList = listResponse?.data ?? [];
          if (_selectedStatusFilter != null) {
            filteredList = filteredList.where(
              (t) => t.status == _selectedStatusFilter,
            ).toList();
          }

          // Catatan: Paginasi Lokal dihapus, kita hanya menampilkan data yang datang dari API halaman saat ini.
          // Kecuali jika Anda ingin paginasi pada hasil filter lokal.
          // Untuk saat ini, kita akan mengandalkan paginasi dari metadata API (currentPage, lastPage).
          
          final int totalPages = listResponse?.lastPage ?? 1;
          
          return PageLayout(
            title: "Tagihan - Daftar",
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_alt),
                onPressed: () => _showFilterDialog(context, controller),
              ),
              TextButton.icon(
                onPressed: () {
                  // TODO: Cetak PDF
                },
                icon: const Icon(Icons.picture_as_pdf, color: Colors.black87),
                label: const Text(
                  "Cetak PDF",
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ],
            body: Column(
              children: [
                if (isLoading)
                  const LinearProgressIndicator(),

                // 3. Penanganan State: Loading, Error, Empty
                if (isError)
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          controller.errorMessage ?? "Gagal memuat data.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  )
                else if (filteredList.isEmpty && !isLoading)
                  const Expanded(
                    child: Center(
                      child: Text("Tidak ada data tagihan ditemukan."),
                    ),
                  )
                else
                  // 4. List View
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final tagihan = filteredList[index];
                        
                        // Konversi status API ke Tampilan Lokal
                        final displayStatus = tagihan.status == 'unpaid' 
                            ? "Belum Dibayar" 
                            : "Sudah Dibayar";
                        final statusColor = tagihan.status == 'paid' 
                            ? Colors.green 
                            : Colors.amber;
                            
                        // Format Nominal
                        final nominalFormatted = NumberFormat.currency(
                            locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                            .format(tagihan.amount);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // --- Header ---
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${((listResponse?.currentPage ?? 1) - 1) * (listResponse?.data.length ?? 0) + index + 1}. ${tagihan.family.kkNumber ?? 'No KK'}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: statusColor[100],
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        displayStatus,
                                        style: TextStyle(
                                          color: statusColor[800],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),
                                const Divider(height: 1),
                                const SizedBox(height: 8),

                                // --- Info Tabel ---
                                Table(
                                  columnWidths: const {
                                    0: FixedColumnWidth(140),
                                    1: FixedColumnWidth(20),
                                    2: FlexColumnWidth(),
                                  },
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  children: [
                                    _buildTableRow("Keluarga (ID)", tagihan.family.id.toString()),
                                    _buildTableRow("Jenis Iuran", tagihan.duesType.name),
                                    _buildTableRow("Kode Tagihan", tagihan.billingCode),
                                    _buildTableRow("Nominal", nominalFormatted),
                                    _buildTableRow("Periode", tagihan.period),
                                    // Mengganti Status Keluarga dengan Status Pembayaran (status)
                                    _buildTableRow("Tanggal Tagih", DateFormat('dd MMMM yyyy').format(tagihan.createdAt)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // 5. Pagination
                if (totalPages > 1 && !isLoading && !isError)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: _currentPage > 1
                              ? () => _fetchData(controller, _currentPage - 1)
                              : null,
                        ),
                        Text(
                          "$_currentPage / $totalPages", // Menampilkan Halaman Saat Ini / Total Halaman
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: _currentPage < totalPages
                              ? () => _fetchData(controller, _currentPage + 1)
                              : null,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}