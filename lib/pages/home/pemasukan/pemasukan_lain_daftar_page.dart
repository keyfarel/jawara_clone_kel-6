import 'package:flutter/material.dart';
import 'package:myapp/models/pemasukan_lain.model.dart';
import '../../../layouts/pages_layout.dart';

class PemasukanLainDaftarPage extends StatefulWidget {
  const PemasukanLainDaftarPage({super.key});

  @override
  State<PemasukanLainDaftarPage> createState() =>
      _PemasukanLainDaftarPageState();
}

class _PemasukanLainDaftarPageState extends State<PemasukanLainDaftarPage> {
  final List<PemasukanLain> pemasukanList = [
    PemasukanLain(
      no: 1,
      nama: "Joki by firman",
      kategori: "Pendapatan Lainnya",
      tanggal: "13 Oktober 2025",
      nominal: 49999997.00,
      tanggalVerifikasi: "14 Oktober 2025",
      verifikator: "Admin Jawara",
    ),
    PemasukanLain(
      no: 2,
      nama: "Tes",
      kategori: "Pendapatan Lainnya",
      tanggal: "12 Agustus 2025",
      nominal: 10000.00,
      tanggalVerifikasi: "13 Agustus 2025",
      verifikator: "Admin Jawara",
    ),
  ];

  // Filter
  String? selectedKategori;
  DateTime? dariTanggal;
  DateTime? sampaiTanggal;
  TextEditingController cariNamaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Pemasukan Lain - Daftar',
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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

            // ===== Redesain daftar data =====
            Expanded(
              child: ListView.separated(
                itemCount: pemasukanList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = pemasukanList[index];
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
                          // Header nama dan nominal
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.nama,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                "Rp ${item.nominal.toStringAsFixed(2)}",
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
                              Text(
                                item.kategori,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.tanggal,
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
  }

  // ======================
  // DETAIL MODAL
  // ======================
  void _showDetail(BuildContext context, PemasukanLain item) {
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
                _detailItem("Nama Pemasukan", item.nama),
                _detailItem("Kategori", item.kategori),
                _detailItem("Tanggal Transaksi", item.tanggal),
                _detailItem(
                  "Jumlah",
                  "Rp ${item.nominal.toStringAsFixed(2)}",
                  color: Colors.green,
                ),
                _detailItem("Tanggal Terverifikasi", item.tanggalVerifikasi),
                _detailItem("Verifikator", item.verifikator),
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
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.grey)),
          Text(value,
              style: TextStyle(
                fontSize: 16,
                color: color ?? Colors.black87,
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }

  // ======================
  // FILTER DIALOG (tetap sama)
  // ======================
  void _showFilterDialog(BuildContext context) {
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
              },
              child: const Text("Reset Filter"),
            ),
            ElevatedButton(
              onPressed: () {
                // logika penerapan filter
                Navigator.pop(context);
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
      String label, DateTime? date, Function(DateTime) onPicked) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (date != null)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => onPicked(DateTime(0))),
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
        hintText: date == null || date.year == 0
            ? "--/--/----"
            : "${date.day}/${date.month}/${date.year}",
      ),
    );
  }
}
