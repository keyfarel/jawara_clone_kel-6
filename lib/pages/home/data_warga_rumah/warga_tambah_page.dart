import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class TambahWargaPage extends StatelessWidget {
  const TambahWargaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Tambah Warga',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pilih Keluarga
              const Text(
                "Pilih Keluarga",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                hint: const Text("-- Pilih Keluarga --"),
                items: const [
                  DropdownMenuItem(value: "1", child: Text("Keluarga Farhan")),
                  DropdownMenuItem(value: "2", child: Text("Keluarga Tes")),
                  DropdownMenuItem(value: "3", child: Text("Keluarga Rendha")),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),

              // Nama
              const Text(
                "Nama",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              const TextField(
                decoration: InputDecoration(
                  hintText: "Masukkan nama lengkap",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // NIK
              const Text(
                "NIK",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              const TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Masukkan NIK sesuai KTP",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Nomor Telepon
              const Text(
                "Nomor Telepon",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              const TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "08xxxxxxxx",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Tempat Lahir
              const Text(
                "Tempat Lahir",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              const TextField(
                decoration: InputDecoration(
                  hintText: "Masukkan tempat lahir",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Tanggal Lahir
              const Text(
                "Tanggal Lahir",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "--/--/----",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      // TODO: tampilkan date picker
                    },
                    icon: const Icon(Icons.calendar_today),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Jenis Kelamin
              const Text(
                "Jenis Kelamin",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                hint: const Text("-- Pilih Jenis Kelamin --"),
                items: const [
                  DropdownMenuItem(value: "Laki-laki", child: Text("Laki-laki")),
                  DropdownMenuItem(value: "Perempuan", child: Text("Perempuan")),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),

              // Agama
              const Text(
                "Agama",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                hint: const Text("-- Pilih Agama --"),
                items: const [
                  DropdownMenuItem(value: "Islam", child: Text("Islam")),
                  DropdownMenuItem(value: "Kristen", child: Text("Kristen")),
                  DropdownMenuItem(value: "Katolik", child: Text("Katolik")),
                  DropdownMenuItem(value: "Hindu", child: Text("Hindu")),
                  DropdownMenuItem(value: "Budha", child: Text("Budha")),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),

              // Golongan Darah
              const Text(
                "Golongan Darah",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                hint: const Text("-- Pilih Golongan Darah --"),
                items: const [
                  DropdownMenuItem(value: "A", child: Text("A")),
                  DropdownMenuItem(value: "B", child: Text("B")),
                  DropdownMenuItem(value: "AB", child: Text("AB")),
                  DropdownMenuItem(value: "O", child: Text("O")),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),

              // Peran Keluarga
              const Text(
                "Peran Keluarga",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                hint: const Text("-- Pilih Peran Keluarga --"),
                items: const [
                  DropdownMenuItem(value: "Kepala Keluarga", child: Text("Kepala Keluarga")),
                  DropdownMenuItem(value: "Istri", child: Text("Istri")),
                  DropdownMenuItem(value: "Anak", child: Text("Anak")),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),

              // Pendidikan Terakhir
              const Text(
                "Pendidikan Terakhir",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                hint: const Text("-- Pilih Pendidikan Terakhir --"),
                items: const [
                  DropdownMenuItem(value: "SD", child: Text("SD")),
                  DropdownMenuItem(value: "SMP", child: Text("SMP")),
                  DropdownMenuItem(value: "SMA", child: Text("SMA")),
                  DropdownMenuItem(value: "S1", child: Text("S1")),
                  DropdownMenuItem(value: "S2", child: Text("S2")),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),

              // Pekerjaan
              const Text(
                "Pekerjaan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                hint: const Text("-- Pilih Jenis Pekerjaan --"),
                items: const [
                  DropdownMenuItem(value: "PNS", child: Text("PNS")),
                  DropdownMenuItem(value: "Wiraswasta", child: Text("Wiraswasta")),
                  DropdownMenuItem(value: "Pelajar", child: Text("Pelajar")),
                  DropdownMenuItem(value: "Tidak Bekerja", child: Text("Tidak Bekerja")),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),

              // Status
              const Text(
                "Status",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                hint: const Text("-- Pilih Status --"),
                items: const [
                  DropdownMenuItem(value: "Aktif", child: Text("Aktif")),
                  DropdownMenuItem(value: "Tidak Aktif", child: Text("Tidak Aktif")),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 24),

              // Tombol Submit & Reset
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Submit"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Reset"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
