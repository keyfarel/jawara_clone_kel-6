import 'package:flutter/material.dart';

class RegisterFormSection extends StatelessWidget {
  const RegisterFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Nama Lengkap"),
        const SizedBox(height: 6),
        const TextField(decoration: InputDecoration(hintText: "Masukkan nama lengkap", border: OutlineInputBorder())),
        const SizedBox(height: 16),

        const Text("NIK"),
        const SizedBox(height: 6),
        const TextField(decoration: InputDecoration(hintText: "Masukkan NIK sesuai KTP", border: OutlineInputBorder())),
        const SizedBox(height: 16),

        const Text("Email"),
        const SizedBox(height: 6),
        const TextField(decoration: InputDecoration(hintText: "Masukkan email aktif", border: OutlineInputBorder())),
        const SizedBox(height: 16),

        const Text("No Telepon"),
        const SizedBox(height: 6),
        const TextField(decoration: InputDecoration(hintText: "08xxxxxxxxx", border: OutlineInputBorder())),
        const SizedBox(height: 16),

        const Text("Password"),
        const SizedBox(height: 6),
        const TextField(obscureText: true, decoration: InputDecoration(hintText: "Masukkan password", border: OutlineInputBorder())),
        const SizedBox(height: 16),

        const Text("Konfirmasi Password"),
        const SizedBox(height: 6),
        const TextField(obscureText: true, decoration: InputDecoration(hintText: "Masukkan ulang password", border: OutlineInputBorder())),
        const SizedBox(height: 16),

        const Text("Jenis Kelamin"),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "-- Pilih Jenis Kelamin --"),
          items: const [
            DropdownMenuItem(value: "Laki-laki", child: Text("Laki-laki")),
            DropdownMenuItem(value: "Perempuan", child: Text("Perempuan")),
          ],
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),

        const Text("Pilih Rumah yang Sudah Ada"),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "-- Pilih Rumah --"),
          items: const [
            DropdownMenuItem(value: "Rumah A", child: Text("Rumah A")),
            DropdownMenuItem(value: "Rumah B", child: Text("Rumah B")),
          ],
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),

        const Text("Kalau tidak ada di daftar, silakan isi alamat rumah di bawah ini", style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 6),

        const Text("Alamat Rumah (Jika Tidak Ada di List)"),
        const SizedBox(height: 6),
        const TextField(decoration: InputDecoration(hintText: "Blok 5A / No.10", border: OutlineInputBorder())),
        const SizedBox(height: 16),

        const Text("Status kepemilikan rumah"),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "-- Pilih Status --"),
          items: const [
            DropdownMenuItem(value: "Milik Sendiri", child: Text("Milik Sendiri")),
            DropdownMenuItem(value: "Sewa", child: Text("Sewa")),
            DropdownMenuItem(value: "Keluarga", child: Text("Keluarga")),
          ],
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),

        const Text("Foto Identitas"),
        const SizedBox(height: 6),
        OutlinedButton(onPressed: () {}, child: const Text("Pilih File")),
      ],
    );
  }
}
