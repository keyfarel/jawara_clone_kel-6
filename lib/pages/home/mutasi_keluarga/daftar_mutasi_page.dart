import 'package:flutter/material.dart';
import 'package:myapp/models/mutasi_keluarga_model.dart';
import '../../../layouts/pages_layout.dart';

class DaftarMutasiPage extends StatefulWidget {
  const DaftarMutasiPage({super.key});

  @override
  State<DaftarMutasiPage> createState() => _DaftarMutasiPageState();
}

class _DaftarMutasiPageState extends State<DaftarMutasiPage> {
  final List<MutasiKeluarga> mutasiList = [
    MutasiKeluarga(
      no: 1,
      tanggal: "30 September 2025",
      keluarga: "Keluarga Mara Nunez",
      jenisMutasi: "Pindah Rumah",
      alamatLama: "Jl. Mawar No. 12, Malang",
      alamatBaru: "Jl. Melati No. 9, Malang",
      alasan: "Ingin rumah yang lebih besar",
      status: "Pindah Rumah",
    ),
    MutasiKeluarga(
      no: 2,
      tanggal: "24 Oktober 2026",
      keluarga: "Keluarga Ijat",
      jenisMutasi: "Pindah Rumah",
      alamatLama: "Jl. Kenanga No. 21",
      alamatBaru: "Jl. Semeru No. 5",
      alasan: "Kebakaran",
      status: "Keluar Perumahan",
    ),
  ];

  // ======= FILTER STATE =======
  String? selectedStatus;
  String? selectedKeluarga;

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: "Mutasi Keluarga - Daftar",
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
                    borderRadius: BorderRadius.circular(8),
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

            // Daftar Mutasi
            Expanded(
              child: ListView.builder(
                itemCount: mutasiList.length,
                itemBuilder: (context, index) {
                  final item = mutasiList[index];
                  return GestureDetector(
                    onTap: () => _showDetail(context, item),
                    child: Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                item.no.toString(),
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                item.tanggal,
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                item.keluarga,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  item.jenisMutasi,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
  }

  // ========================
  // DETAIL BOTTOM SHEET
  // ========================
  void _showDetail(BuildContext context, MutasiKeluarga item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const Text(
                "Detail Mutasi Keluarga",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              _detailItem("Keluarga", item.keluarga),
              _detailItem("Alamat Lama", item.alamatLama),
              _detailItem("Alamat Baru", item.alamatBaru),
              _detailItem("Tanggal Mutasi", item.tanggal),
              _detailItem("Jenis Mutasi", item.jenisMutasi),
              _detailItem("Alasan", item.alasan),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.close),
                  label: const Text("Tutup"),
                  onPressed: () => Navigator.pop(context),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
          Text(value,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
        ],
      ),
    );
  }

  // ========================
  // FILTER DIALOG
  // ========================
  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Filter Mutasi Keluarga"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                ),
                items: ["Pindah Rumah", "Keluar Perumahan"]
                    .map((status) => DropdownMenuItem(
                    value: status, child: Text(status)))
                    .toList(),
                onChanged: (val) => setState(() => selectedStatus = val),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedKeluarga,
                decoration: const InputDecoration(
                  labelText: "Keluarga",
                  border: OutlineInputBorder(),
                ),
                items: [
                  "Keluarga Mara Nunez",
                  "Keluarga Ijat",
                  "Keluarga Dodi"
                ]
                    .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                    .toList(),
                onChanged: (val) => setState(() => selectedKeluarga = val),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedStatus = null;
                  selectedKeluarga = null;
                });
                Navigator.pop(context);
              },
              child: const Text("Reset Filter"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
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
}
