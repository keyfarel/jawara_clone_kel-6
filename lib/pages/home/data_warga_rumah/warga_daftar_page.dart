
import 'package:flutter/material.dart';
import '../../../models/warga_model.dart';

class WargaDaftarPage extends StatefulWidget {
  const WargaDaftarPage({super.key});

  @override
  State<WargaDaftarPage> createState() => _WargaDaftarPageState();
}

class _WargaDaftarPageState extends State<WargaDaftarPage> {
  List<Warga> daftarWarga = [
    Warga(
      id: '1', 
      nama: 'Ahmad', 
      alamat: 'Jl. Merdeka No.1', 
      noTelepon: '08123456789', 
      status: 'Aktif'
    ),
    Warga(
      id: '2', 
      nama: 'Siti', 
      alamat: 'Jl. Merdeka No.2', 
      noTelepon: '08123456788', 
      status: 'Aktif'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Warga'),
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
        itemCount: daftarWarga.length,
        itemBuilder: (context, index) {
          final warga = daftarWarga[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(warga.nama[0])),
              title: Text(warga.nama),
              subtitle: Text('${warga.alamat} - ${warga.noTelepon}'),
              trailing: Chip(
                label: Text(
                  warga.status,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: warga.status == 'Aktif' ? Colors.green : Colors.red,
              ),
              onTap: () {
                // Navigasi ke detail warga
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke tambah warga
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}