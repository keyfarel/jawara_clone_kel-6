import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/layouts/pages_layout.dart';
import '../../controllers/semua_pengeluaran_controller.dart';
import '../../data/models/semua_pengeluaran_model.dart';

class SemuaPengeluaranPage extends StatefulWidget {
  const SemuaPengeluaranPage({super.key});

  @override
  State<SemuaPengeluaranPage> createState() => _SemuaPengeluaranPageState();
}

class _SemuaPengeluaranPageState extends State<SemuaPengeluaranPage> {
  late SemuaPengeluaranController _controller;
  String? selectedJenis;

  final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _controller = SemuaPengeluaranController();
    _controller.loadData();
  }

  String formatTanggal(DateTime date) {
    try {
      return DateFormat('dd MMM yyyy', 'id_ID').format(date);
    } catch (_) {
      return DateFormat('dd MMM yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: "Semua Pengeluaran",
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_alt),
          onPressed: () => _showFilterDialog(context),
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => _controller.loadData(),
        ),
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Ganti 'RouteTambahPengeluaran' dengan route halaman input Anda
          final result = await Navigator.pushNamed(context, '/tambah-pengeluaran');
          
          // Jika hasil dari halaman tambah adalah true, refresh data
          if (result == true) {
            _controller.loadData();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () => _controller.loadData(),
        child: ValueListenableBuilder<bool>(
          valueListenable: _controller.isLoading,
          builder: (context, loading, _) {
            if (loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return ValueListenableBuilder<String?>(
              valueListenable: _controller.errorMessage,
              builder: (context, error, _) {
                if (error != null) {
                  return ListView( // Gunakan ListView agar bisa pull-to-refresh saat error
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                      Center(
                        child: Column(
                          children: [
                            const Icon(Icons.error_outline, size: 60, color: Colors.red),
                            const SizedBox(height: 16),
                            Text("Terjadi Kesalahan:\n$error", textAlign: TextAlign.center),
                            ElevatedButton(
                              onPressed: () => _controller.loadData(),
                              child: const Text("Coba Lagi"),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return ValueListenableBuilder<List<SemuaPengeluaranModel>>(
                  valueListenable: _controller.listPengeluaran,
                  builder: (context, data, _) {
                    final filteredList = selectedJenis == null
                        ? data
                        : data.where((p) => p.categoryName == selectedJenis).toList();

                    if (filteredList.isEmpty) {
                      return ListView(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                          const Center(child: Text("Data pengeluaran tidak ditemukan.")),
                        ],
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        return _buildCard(filteredList[index], index);
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard(SemuaPengeluaranModel item, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red[50],
          child: Text("${index + 1}", 
            style: TextStyle(color: Colors.red[900], fontWeight: FontWeight.bold)),
        ),
        title: Text(item.title, 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(currencyFormatter.format(item.nominal), 
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow(Icons.category, "Kategori", item.categoryName),
                _infoRow(Icons.calendar_today, "Tanggal", formatTanggal(item.transactionDate)),
                if (item.description != null && item.description!.isNotEmpty)
                  _infoRow(Icons.description, "Keterangan", item.description!),
                
                const Divider(height: 20),
                const Text("Bukti Transaksi:", 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                
                if (item.proofImageLink != null && item.proofImageLink!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.proofImageLink!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      // Header wajib untuk bypass Ngrok warning
                      headers: const {'ngrok-skip-browser-warning': 'true'},
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 100,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image, color: Colors.grey),
                              Text("Gambar tidak tersedia", 
                                  style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                else
                  const Text("Tidak ada lampiran gambar", 
                      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final jenisList = _controller.listPengeluaran.value
        .map((p) => p.categoryName)
        .toSet()
        .toList();

    showDialog(
      context: context,
      builder: (context) {
        String? tempJenis = selectedJenis;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Filter Kategori"),
              content: DropdownButtonFormField<String>(
                value: tempJenis,
                isExpanded: true,
                items: jenisList.map((j) => DropdownMenuItem(value: j, child: Text(j))).toList(),
                onChanged: (val) => setDialogState(() => tempJenis = val),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Pilih Kategori",
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() => selectedJenis = null);
                    Navigator.pop(context);
                  }, 
                  child: const Text("Reset")
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() => selectedJenis = tempJenis);
                    Navigator.pop(context);
                  }, 
                  child: const Text("Terapkan")
                ),
              ],
            );
          }
        );
      },
    );
  }
}