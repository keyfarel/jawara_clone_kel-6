import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/layouts/pages_layout.dart';
import '../../../../core/routes/app_routes.dart'; // Pastikan path benar
import '../../../../features/dashboard/controllers/dashboard_controller.dart';
import '../../controllers/family_controller.dart';
import '../../controllers/rumah_controller.dart';

class KeluargaTambahPage extends StatefulWidget {
  const KeluargaTambahPage({super.key});

  @override
  State<KeluargaTambahPage> createState() => _KeluargaTambahPageState();
}

class _KeluargaTambahPageState extends State<KeluargaTambahPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _kkController = TextEditingController();

  int? _selectedHouseId;
  String _ownershipStatus = 'owner';
  String _status = 'active';

  @override
  void initState() {
    super.initState();
    // Load data Rumah saat awal
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RumahController>().loadHouses();
    });
  }

  // --- LOGIC 1: Redirect ke Tambah Rumah & Refresh Dropdown ---
  Future<void> _goToTambahRumah() async {
    // Navigate ke halaman tambah rumah
    await Navigator.pushNamed(context, '/rumah_tambah');
    
    // Setelah kembali, refresh data rumah agar rumah baru muncul di dropdown
    if (mounted) {
      context.read<RumahController>().loadHouses();
    }
  }

  // --- LOGIC 2: Submit & Redirect ke Tambah Warga ---
  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final Map<String, dynamic> data = {
        "kk_number": _kkController.text,
        "house_id": _selectedHouseId,
        "ownership_status": _ownershipStatus,
        "status": _status,
      };

      final familyController = context.read<FamilyController>();
      
      // Simpan Keluarga
      final success = await familyController.addFamily(data);

      if (mounted) {
        if (success) {
          // Update Dashboard
          context.read<DashboardController>().refreshData();

          // Tampilkan Dialog Sukses dengan Opsi
          _showSuccessDialog();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(familyController.errorMessage ?? "Gagal menyimpan"), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  // Dialog Sukses dengan Opsi Redirect
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // User harus memilih
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Berhasil!"),
          content: const Text("Data Keluarga berhasil dibuat.\nApakah Anda ingin langsung menambahkan Anggota Keluarga (Warga)?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Tutup dialog
                Navigator.pop(context); // Kembali ke Daftar Keluarga
              },
              child: const Text("Nanti Saja"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx); // Tutup dialog
                // Redirect ke Halaman Tambah Warga
                // (Opsional: Anda bisa mengirim argumen No KK agar otomatis terisi di sana)
                Navigator.popAndPushNamed(context, '/warga_tambah'); 
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
              child: const Text("Ya, Tambah Warga"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final rumahController = context.watch<RumahController>();
    final familyController = context.watch<FamilyController>();

    return PageLayout(
      title: "Tambah Keluarga",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Field No KK ---
              TextFormField(
                controller: _kkController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Nomor Kartu Keluarga (KK)",
                  hintText: "16 digit nomor KK",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.credit_card),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Wajib diisi";
                  if (value.length < 16) return "Minimal 16 digit";
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // --- Dropdown Rumah dengan Tombol Tambah ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _selectedHouseId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: "Pilih Rumah",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.home),
                      ),
                      hint: const Text("Pilih lokasi..."),
                      items: rumahController.houses.map((rumah) {
                        return DropdownMenuItem<int>(
                          value: rumah.id,
                          child: Text(
                            "${rumah.houseName} (${rumah.statusDisplay})",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedHouseId = val),
                      validator: (val) => val == null ? "Wajib pilih rumah" : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Tombol Shortcut Tambah Rumah
                  Container(
                    height: 55, // Tinggi disamakan dengan input field
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.blue.shade200)
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add_home, color: Colors.blue),
                      tooltip: "Buat Rumah Baru",
                      onPressed: _goToTambahRumah,
                    ),
                  ),
                ],
              ),
              
              // Helper Text jika list kosong
              if (rumahController.houses.isEmpty && !rumahController.isLoading)
                 Padding(
                   padding: const EdgeInsets.only(top: 8.0),
                   child: InkWell(
                     onTap: _goToTambahRumah,
                     child: const Text(
                       "Data rumah kosong. Klik di sini untuk menambah rumah baru.", 
                       style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)
                     ),
                   ),
                 ),

              const SizedBox(height: 16),

              // --- Status ---
              DropdownButtonFormField<String>(
                value: _ownershipStatus,
                decoration: const InputDecoration(
                  labelText: "Status Kepemilikan",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.vpn_key),
                ),
                items: const [
                  DropdownMenuItem(value: "owner", child: Text("Milik Sendiri")),
                  DropdownMenuItem(value: "renter", child: Text("Kontrak/Sewa")),
                ],
                onChanged: (val) => setState(() => _ownershipStatus = val!),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: "Status KK",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.info),
                ),
                items: const [
                  DropdownMenuItem(value: "active", child: Text("Aktif")),
                  DropdownMenuItem(value: "moved", child: Text("Pindah")),
                ],
                onChanged: (val) => setState(() => _status = val!),
              ),

              const SizedBox(height: 32),

              // --- Tombol Simpan ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: familyController.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: familyController.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Simpan Data Keluarga", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}