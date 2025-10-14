import 'package:flutter/material.dart';
import 'package:myapp/layouts/pages_layout.dart';
import 'package:myapp/models/rumah_model.dart';

class RumahDaftarPage extends StatefulWidget {
  const RumahDaftarPage({super.key});

  @override
  State<RumahDaftarPage> createState() => _RumahDaftarPageState();
}

class _RumahDaftarPageState extends State<RumahDaftarPage> {
  List<Rumah> daftarRumah = [
    Rumah(no: 1, alamat: "Jl. Baru bangun", status: "Ditempati"),
    Rumah(no: 2, alamat: "Jl. Melati No. 3, Surabaya", status: "Tersedia"),
    Rumah(no: 3, alamat: "Jl. Kenanga No. 8, Batu", status: "Ditempati"),
    Rumah(no: 4, alamat: "Blok A49", status: "Tersedia"),
  ];

  String? selectedStatus; // filter

  @override
  Widget build(BuildContext context) {
    // filter rumah berdasarkan status
    final List<Rumah> filteredList = selectedStatus == null
        ? daftarRumah
        : daftarRumah
        .where((r) => r.status == selectedStatus)
        .toList();

    return PageLayout(
      title: "Rumah - Daftar",
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_alt),
          onPressed: () {
            _showFilterDialog(context);
          },
        ),
      ],
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          final rumah = filteredList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: rumah.status == "Tersedia"
                    ? Colors.green
                    : Colors.blueAccent,
                child: Text(rumah.no.toString(),
                    style: const TextStyle(color: Colors.white)),
              ),
              title: Text(rumah.alamat,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text("Status: ${rumah.status}"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showDetail(context, rumah);
              },
            ),
          );
        },
      ),
    );
  }

  // === FILTER DIALOG ===
  void _showFilterDialog(BuildContext context) {
    String tempSearchAlamat = '';
    String? tempStatus = selectedStatus;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filter Rumah"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔍 Input Alamat
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Alamat",
                    hintText: "Cari nama...",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    tempSearchAlamat = val;
                  },
                ),
                const SizedBox(height: 16),

                // 🏠 Dropdown Status
                DropdownButtonFormField<String>(
                  value: tempStatus,
                  items: ["Tersedia", "Ditempati"]
                      .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
                      .toList(),
                  onChanged: (val) {
                    tempStatus = val;
                  },
                  decoration: const InputDecoration(
                    labelText: "Pilih Status",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            // 🔁 Reset Filter
            TextButton(
              onPressed: () {
                setState(() {
                  selectedStatus = null;
                  // kalau kamu punya variable search text, reset juga di sini
                });
                Navigator.pop(context);
              },
              child: const Text("Reset Filter"),
            ),

            // ✅ Terapkan Filter
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              onPressed: () {
                setState(() {
                  selectedStatus = tempStatus;
                  // kalau kamu punya variabel pencarian, simpan di sini juga
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


  // === DETAIL RUMAH ===
  void _showDetail(BuildContext context, Rumah rumah) {

    final List<Map<String, String>> riwayatPenghuni = [

    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Garis kecil di atas
                Center(
                  child: Container(
                    height: 5,
                    width: 40,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),

                // Judul detail
                Text(
                  "Detail Rumah #${rumah.no}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),

                // Informasi dasar
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Alamat"),
                  subtitle: Text(rumah.alamat),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Status"),
                  subtitle: Text(
                    rumah.status,
                    style: TextStyle(
                      color: rumah.status == "Tersedia"
                          ? Colors.green
                          : Colors.blueAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // 🏠 Bagian Riwayat Penghuni
                const Text(
                  "Riwayat Penghuni",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                if (riwayatPenghuni.isEmpty)
                  const Text(
                    "Belum ada riwayat penghuni.",
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  Column(
                    children: riwayatPenghuni
                        .map(
                          (p) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 1,
                        child: ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: Text(p['nama']!),
                          subtitle: Text(p['periode']!),
                        ),
                      ),
                    )
                        .toList(),
                  ),

                const SizedBox(height: 20),

                // Tombol Tutup
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
}
