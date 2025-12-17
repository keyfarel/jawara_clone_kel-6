import 'package:flutter/material.dart';
import 'package:myapp/widgets/layouts/pages_layout.dart';
import '../data/models/pengeluaran_model.dart';
import '../controllers/pengeluaran_controller.dart';
import 'tambah_page.dart'; // Import halaman tambah

class PengeluaranDaftarPage extends StatefulWidget {
  const PengeluaranDaftarPage({super.key});

  @override
  State<PengeluaranDaftarPage> createState() => _PengeluaranDaftarPageState();
}

class _PengeluaranDaftarPageState extends State<PengeluaranDaftarPage> {
  final PengeluaranController _controller = PengeluaranController();
  List<Pengeluaran> daftarPengeluaran = [];
  String? selectedJenis;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      daftarPengeluaran = _controller.getPengeluaran(filterJenis: selectedJenis);
    });
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
        // Tombol Tambah Data
        IconButton(
          icon: const Icon(Icons.add_circle, size: 28),
          onPressed: () async {
            // Navigasi ke halaman tambah dan tunggu hasil (await)
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TambahPage()),
            );
            // Refresh data setelah kembali
            _loadData();
          },
        ),
      ],
      body: daftarPengeluaran.isEmpty 
          ? const Center(child: Text("Belum ada data pengeluaran."))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: daftarPengeluaran.length,
        itemBuilder: (context, index) {
          final pengeluaran = daftarPengeluaran[index];
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
                      child: Text("${index + 1}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pengeluaran.nama,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 10,
                          runSpacing: 4,
                          children: [
                            _infoChip(
                              pengeluaran.jenisPengeluaran,
                              Colors.blue[100]!,
                              Colors.blue[800]!,
                            ),
                            _infoText("Tanggal", _controller.formatTanggal(pengeluaran.tanggal)),
                            _infoText("Nominal", _controller.formatRupiah(pengeluaran.nominal)),
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
  }

  // === Dialog Filter ===
  void _showFilterDialog(BuildContext context) {
    String? tempJenis = selectedJenis;
    // Ambil list jenis unik dari repository
    final allData = _controller.getPengeluaran(); 
    final jenisList = allData.map((p) => p.jenisPengeluaran).toSet().toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filter Pengeluaran"),
          content: DropdownButtonFormField<String>(
            value: tempJenis,
            items: jenisList.map((jenis) => DropdownMenuItem(value: jenis, child: Text(jenis))).toList(),
            onChanged: (val) => tempJenis = val,
            decoration: const InputDecoration(labelText: "Pilih Jenis", border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() => selectedJenis = null);
                _loadData();
                Navigator.pop(context);
              },
              child: const Text("Reset"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => selectedJenis = tempJenis);
                _loadData();
                Navigator.pop(context);
              },
              child: const Text("Terapkan"),
            ),
          ],
        );
      },
    );
  }

  // === Widgets Kecil ===
  Widget _infoChip(String value, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
      child: Text(value, style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 12)),
    );
  }

  Widget _infoText(String label, String value) {
    return Text("$label: $value", style: const TextStyle(fontSize: 13, color: Colors.black87));
  }
}