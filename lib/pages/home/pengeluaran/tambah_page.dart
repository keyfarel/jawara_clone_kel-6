import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class TambahPage extends StatelessWidget {
  const TambahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Buat Pengeluaran Baru',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama Pengeluaran
              const Text(
                "Nama Pengeluaran",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              const TextField(
                decoration: InputDecoration(
                  hintText: "Masukkan nama pengeluaran",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Tanggal Pengeluaran
              const Text(
                "Tanggal Pengeluaran",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: false, // hanya tampilan, belum berfungsi
                      decoration: InputDecoration(
                        hintText: "--/--/----",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: null,
                          icon: const Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Kategori Pengeluaran
              const Text(
                "Kategori Pengeluaran",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                hint: const Text("-- Pilih Kategori --"),
                items: const [
                  DropdownMenuItem(value: "Makanan", child: Text("Makanan")),
                  DropdownMenuItem(value: "Transportasi", child: Text("Transportasi")),
                  DropdownMenuItem(value: "Listrik", child: Text("Listrik")),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),

              // Nominal
              const Text(
                "Nominal",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              const TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Masukkan nominal",
                ),
              ),
              const SizedBox(height: 16),

              // Bukti Pengeluaran
              const Text(
                "Bukti Pengeluaran",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey[200],
                ),
                child: const Center(
                  child: Text(
                    "Upload bukti pengeluaran (.png/.jpg)",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
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
