// lib/features/data_warga_rumah/presentation/pages/tambah_warga_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; 

import '../../../../layouts/pages_layout.dart';
import '../../controllers/citizen_controller.dart';

class TambahWargaPage extends StatefulWidget {
  const TambahWargaPage({super.key});

  @override
  State<TambahWargaPage> createState() => _TambahWargaPageState();
}

class _TambahWargaPageState extends State<TambahWargaPage> {
  final _formKey = GlobalKey<FormState>();

  // --- Controllers ---
  final _nameController = TextEditingController();
  final _nikController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _birthDateController = TextEditingController();

  // --- State Variables for Dropdowns ---
  String? _selectedFamilyId;
  String? _selectedUserId; // Bisa Null
  String? _selectedGender;
  String? _selectedReligion;
  String? _selectedBloodType;
  String? _selectedRole;
  String? _selectedEducation;
  String? _selectedOccupation;
  String? _selectedStatus; // Default null, backend set active

  @override
  void initState() {
    super.initState();
    // Load Opsi Keluarga & User saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CitizenController>().loadInitialData();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _phoneController.dispose();
    _birthPlaceController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  // Helper Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Helper Get Label Keluarga
  // Menangani struktur JSON yang mungkin berbeda
  String _getFamilyLabel(dynamic family) {
    // Sesuai response API: family_name
    if (family['family_name'] != null) {
      return "${family['family_name']}";
    }
    // Fallback jika null
    return "Keluarga ID ${family['id']}";
  }

  // Logic Submit
  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Persiapkan Data JSON
    final data = {
      "family_id": int.tryParse(_selectedFamilyId ?? "0"),
      
      // LOGIC: Jika null, kirim null (jangan kirim string "null" atau angka 0)
      "user_id": _selectedUserId != null ? int.tryParse(_selectedUserId!) : null,
      
      "nik": _nikController.text,
      "name": _nameController.text,
      "phone": _phoneController.text.isEmpty ? null : _phoneController.text,
      "birth_place": _birthPlaceController.text,
      "birth_date": _birthDateController.text,
      
      "gender": _selectedGender == "Laki-laki" ? "male" : "female",
      "religion": _selectedReligion,
      "blood_type": _selectedBloodType,
      "family_role": _selectedRole?.toLowerCase(), // Mapping: 'Kepala Keluarga' -> 'kepala keluarga' (backend perlu handle lowercase/mapping)
      
      // Default ke "Lainnya" jika kosong
      "education": _selectedEducation ?? "Lainnya",
      "occupation": _selectedOccupation ?? "Lainnya",
      
      "status": _selectedStatus == "Tidak Aktif" ? "inactive" : "active",
      "id_card_photo": null,
    };

    // Mapping manual role agar sesuai Enum database (husband, wife, son, daughter, head_family)
    // Sesuaikan string di bawah ini dengan ENUM di database Laravel Anda
    if (_selectedRole == "Kepala Keluarga") data["family_role"] = "head_of_family"; // atau "husband"
    else if (_selectedRole == "Istri") data["family_role"] = "wife";
    else if (_selectedRole == "Anak") data["family_role"] = "child";
    else data["family_role"] = "other";

    final controller = context.read<CitizenController>();
    final success = await controller.addCitizen(data);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Berhasil menambah warga!"), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(controller.errorMessage ?? "Gagal"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CitizenController>();

    return PageLayout(
      title: 'Tambah Warga',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      controller.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                // --- 1. PILIH KELUARGA ---
               const Text("Pilih Keluarga", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "-- Pilih Keluarga --"),
                  value: _selectedFamilyId,
                  // START UPDATE
                  items: controller.familyOptions.map<DropdownMenuItem<String>>((family) {
                    return DropdownMenuItem<String>(
                      value: family['id'].toString(),
                      child: Text(
                        _getFamilyLabel(family), // <--- Ini akan memanggil fungsi baru di atas
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  // END UPDATE
                  onChanged: (val) => setState(() => _selectedFamilyId = val),
                  validator: (val) => val == null ? "Wajib dipilih" : null,
                ),
                const SizedBox(height: 16),

                // --- 2. TAUTKAN AKUN USER (OPSIONAL) ---
                const Text("Tautkan Akun User (Opsional)", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Pilih Akun (Kosongkan jika anak/bayi)"),
                  value: _selectedUserId,
                  isExpanded: true,
                  items: [
                     // Opsi Kosong
                    const DropdownMenuItem<String>(
                      value: null, 
                      child: Text("Tidak / Belum punya akun", style: TextStyle(color: Colors.grey)),
                    ),
                    // List User dari API
                    ...controller.userOptions.map<DropdownMenuItem<String>>((user) {
                      return DropdownMenuItem<String>(
                        value: user['id'].toString(),
                        child: Text("${user['name']}", overflow: TextOverflow.ellipsis),
                      );
                    }),
                  ],
                  onChanged: (val) => setState(() => _selectedUserId = val),
                  // Tidak ada validator karena optional
                ),
                const SizedBox(height: 16),

                // --- 3. DATA PRIBADI ---
                const Text("Nama Lengkap", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Masukkan Nama"),
                  validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
                ),
                const SizedBox(height: 16),

                const Text("NIK", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nikController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "16 Digit NIK"),
                  validator: (val) => val!.length < 16 ? "NIK minimal 16 digit" : null,
                ),
                const SizedBox(height: 16),

                const Text("Nomor Telepon (Opsional)", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "08..."),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Tempat Lahir", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _birthPlaceController,
                            decoration: const InputDecoration(border: OutlineInputBorder()),
                            validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Tanggal Lahir", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _birthDateController,
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "YYYY-MM-DD",
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // --- 4. DROPDOWNS DATA DIRI ---
                const Text("Jenis Kelamin", style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  hint: const Text("-- Pilih --"),
                  value: _selectedGender,
                  items: ["Laki-laki", "Perempuan"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) => setState(() => _selectedGender = val),
                  validator: (val) => val == null ? "Wajib dipilih" : null,
                ),
                const SizedBox(height: 16),

                const Text("Agama", style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  hint: const Text("-- Pilih --"),
                  value: _selectedReligion,
                  items: ["Islam", "Kristen", "Katolik", "Hindu", "Budha", "Konghucu", "Lainnya"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) => setState(() => _selectedReligion = val),
                ),
                const SizedBox(height: 16),

                const Text("Peran Keluarga", style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  hint: const Text("-- Pilih --"),
                  value: _selectedRole,
                  items: ["Kepala Keluarga", "Istri", "Anak", "Lainnya"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) => setState(() => _selectedRole = val),
                  validator: (val) => val == null ? "Wajib dipilih" : null,
                ),
                const SizedBox(height: 16),

                // --- 5. PENDIDIKAN & PEKERJAAN ---
                const Text("Pendidikan Terakhir", style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  hint: const Text("-- Pilih --"),
                  value: _selectedEducation,
                  items: ["SD", "SMP", "SMA/SMK", "D3", "S1", "S2", "S3", "Tidak Sekolah", "Lainnya"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) => setState(() => _selectedEducation = val),
                ),
                const SizedBox(height: 16),

                const Text("Pekerjaan", style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  hint: const Text("-- Pilih --"),
                  value: _selectedOccupation,
                  items: ["PNS", "Wiraswasta", "Swasta", "Pelajar/Mahasiswa", "Ibu Rumah Tangga", "Belum Bekerja", "Pensiunan", "Lainnya"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) => setState(() => _selectedOccupation = val),
                ),
                const SizedBox(height: 16),
                // --- 6. TOMBOL SUBMIT ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: controller.isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("SIMPAN DATA WARGA", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}