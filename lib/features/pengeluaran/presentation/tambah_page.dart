import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../layouts/pages_layout.dart';
import '../controllers/pengeluaran_controller.dart';

class TambahPage extends StatefulWidget {
  const TambahPage({super.key});

  @override
  State<TambahPage> createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = PengeluaranController();
  
  // Input Controllers
  final TextEditingController _namaCtrl = TextEditingController();
  final TextEditingController _nominalCtrl = TextEditingController();
  final TextEditingController _dateCtrl = TextEditingController(); // Untuk tampilan tanggal
  
  DateTime? _selectedDate;
  String? _selectedKategori;

  final List<String> _kategoriList = [
    "Kegiatan Warga", 
    "Pemeliharaan Fasilitas", 
    "Operasional RT/RW",
    "Lainnya"
  ];

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateCtrl.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedDate != null && _selectedKategori != null) {
      // Simpan data lewat controller
      _controller.tambahPengeluaran(
        nama: _namaCtrl.text,
        jenis: _selectedKategori!,
        tanggal: _selectedDate!,
        nominalStr: _nominalCtrl.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data berhasil disimpan!")),
      );

      Navigator.pop(context); // Kembali ke halaman daftar
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon lengkapi semua data")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Buat Pengeluaran Baru',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Nama Pengeluaran"),
              TextFormField(
                controller: _namaCtrl,
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
                decoration: const InputDecoration(
                  hintText: "Masukkan nama pengeluaran",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              _buildLabel("Tanggal"),
              TextFormField(
                controller: _dateCtrl,
                readOnly: true,
                onTap: _pickDate,
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
                decoration: const InputDecoration(
                  hintText: "--/--/----",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 16),

              _buildLabel("Kategori"),
              DropdownButtonFormField<String>(
                value: _selectedKategori,
                items: _kategoriList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _selectedKategori = val),
                validator: (val) => val == null ? "Wajib dipilih" : null,
                decoration: const InputDecoration(
                  hintText: "-- Pilih Kategori --",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              _buildLabel("Nominal"),
              TextFormField(
                controller: _nominalCtrl,
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
                decoration: const InputDecoration(
                  prefixText: "Rp ",
                  hintText: "0",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Simpan"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: const Text("Batal"),
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}