import 'package:flutter/material.dart';
import 'package:myapp/layouts/pages_layout.dart';
import '../../../../models/keluarga_model.dart';

class KeluargaDaftarPage extends StatefulWidget {
  const KeluargaDaftarPage({super.key});

  @override
  State<KeluargaDaftarPage> createState() => _KeluargaDaftarPageState();
}

class _KeluargaDaftarPageState extends State<KeluargaDaftarPage> {
  List<Keluarga> daftarKeluarga = [
    Keluarga(
      id: '1',
      namaKeluarga: 'Keluarga Tes',
      kepalaKeluarga: 'Tes',
      alamatRumah: 'Tes',
      statusKepemilikan: 'Penyewa',
      status: 'Aktif',
    ),
    Keluarga(
      id: '2',
      namaKeluarga: 'Keluarga Farhan',
      kepalaKeluarga: 'Farhan',
      alamatRumah: 'Griyashanta L.203',
      statusKepemilikan: 'Pemilik',
      status: 'Aktif',
    ),
    Keluarga(
      id: '3',
      namaKeluarga: 'Keluarga Rendha Putra Rahmadya',
      kepalaKeluarga: 'Rendha Putra Rahmadya',
      alamatRumah: 'Malang',
      statusKepemilikan: 'Pemilik',
      status: 'Tidak Aktif',
    ),
  ];

  String? selectedStatus; // filter status keluarga

  @override
  Widget build(BuildContext context) {
    // filter daftar keluarga berdasarkan status
    final List<Keluarga> filteredList = selectedStatus == null
        ? daftarKeluarga
        : daftarKeluarga
            .where((k) => k.status == selectedStatus)
            .toList();

    return PageLayout(
      title: "Keluarga - Daftar",
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
          final keluarga = filteredList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    keluarga.status == "Aktif" ? Colors.green : Colors.redAccent,
                child: Text(
                  keluarga.kepalaKeluarga.isNotEmpty
                      ? keluarga.kepalaKeluarga[0].toUpperCase()
                      : '?',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                keluarga.namaKeluarga,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                  "Alamat: ${keluarga.alamatRumah}\nStatus: ${keluarga.statusKepemilikan}"),
              isThreeLine: true,
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showDetail(context, keluarga);
              },
            ),
          );
        },
      ),
    );
  }

  // === FILTER DIALOG ===
  void _showFilterDialog(BuildContext context) {
    String? tempStatus = selectedStatus;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filter Keluarga"),
          content: DropdownButtonFormField<String>(
            value: tempStatus,
            items: ["Aktif", "Tidak Aktif"]
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
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedStatus = null;
                });
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
                  selectedStatus = tempStatus;
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

  // === DETAIL KELUARGA ===
  void _showDetail(BuildContext context, Keluarga keluarga) {
    final List<Map<String, String>> anggotaKeluarga = [
      // contoh jika ingin tampilkan data anggota
      // {'nama': 'Farhan', 'hubungan': 'Kepala Keluarga'},
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
                Text(
                  "Detail ${keluarga.namaKeluarga}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Kepala Keluarga"),
                  subtitle: Text(keluarga.kepalaKeluarga),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Alamat Rumah"),
                  subtitle: Text(keluarga.alamatRumah),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Status Kepemilikan"),
                  subtitle: Text(keluarga.statusKepemilikan),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Status"),
                  subtitle: Text(
                    keluarga.status,
                    style: TextStyle(
                      color: keluarga.status == "Aktif"
                          ? Colors.green
                          : Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Anggota Keluarga",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),

                if (anggotaKeluarga.isEmpty)
                  const Text(
                    "Belum ada data anggota keluarga.",
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  Column(
                    children: anggotaKeluarga
                        .map(
                          (a) => Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.person_outline),
                              title: Text(a['nama']!),
                              subtitle: Text(a['hubungan']!),
                            ),
                          ),
                        )
                        .toList(),
                  ),

                const SizedBox(height: 20),

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
