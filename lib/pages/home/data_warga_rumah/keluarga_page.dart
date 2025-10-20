import 'package:flutter/material.dart';
import '../../../models/keluarga_model.dart';

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
      status: 'Aktif',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Keluarga'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implementasi pencarian
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: daftarKeluarga.length,
        itemBuilder: (context, index) {
          final keluarga = daftarKeluarga[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(
                  keluarga.kepalaKeluarga.isNotEmpty
                      ? keluarga.kepalaKeluarga[0].toUpperCase()
                      : '?',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(keluarga.namaKeluarga,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kepala: ${keluarga.kepalaKeluarga}'),
                  Text('Alamat: ${keluarga.alamatRumah}'),
                  Text('Kepemilikan: ${keluarga.statusKepemilikan}'),
                ],
              ),
              trailing: Chip(
                label: Text(
                  keluarga.status,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor:
                    keluarga.status == 'Aktif' ? Colors.green : Colors.red,
              ),
              onTap: () {
                // Navigasi ke detail keluarga
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke tambah keluarga
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
