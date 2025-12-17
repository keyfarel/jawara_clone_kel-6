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
  
  // Controller Baru (Untuk KK Baru)
  final _addressController = TextEditingController();

  // --- State Variables ---
  bool _isNewFamily = false; // Toggle: Tambah ke KK lama atau Buat KK baru
  
  String? _selectedFamilyId;
  String? _selectedUserId;
  String? _selectedGender;
  String? _selectedReligion;
  String? _selectedBloodType;
  String? _selectedRole;
  String? _selectedEducation;
  String? _selectedOccupation;
  String? _selectedStatus;
  
  // State Baru (Untuk KK Baru)
  String? _selectedOwnership; 

  final Color primaryColor = Colors.blue;

  @override
  void initState() {
    super.initState();
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
    _addressController.dispose();
    super.dispose();
  }

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

  String _getFamilyLabel(dynamic family) {
    if (family['family_name'] != null) {
      return "${family['family_name']}";
    }
    return "Keluarga ID ${family['id']}";
  }

  // --- LOGIC SUBMIT (UPDATED) ---
  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // 1. Base Data (Data Diri Warga)
    final data = {
      "user_id": _selectedUserId != null ? int.tryParse(_selectedUserId!) : null,
      "nik": _nikController.text,
      "name": _nameController.text,
      "phone": _phoneController.text.isEmpty ? null : _phoneController.text,
      "birth_place": _birthPlaceController.text,
      "birth_date": _birthDateController.text,
      "gender": _selectedGender == "Laki-laki" ? "male" : "female",
      "religion": _selectedReligion,
      "blood_type": _selectedBloodType,
      "education": _selectedEducation ?? "Lainnya",
      "occupation": _selectedOccupation ?? "Lainnya",
      "status": _selectedStatus == "Tidak Aktif" ? "inactive" : "active",
      "id_card_photo": null,
    };

    // 2. Logic Role Mapping
    String roleToSend = "other";
    if (_selectedRole == "Kepala Keluarga") roleToSend = "head_of_family";
    else if (_selectedRole == "Istri") roleToSend = "wife";
    else if (_selectedRole == "Anak") roleToSend = "child";
    
    data["family_role"] = roleToSend;

    // 3. Logic Family / House (Sesuai Backend Store)
    if (_isNewFamily) {
      // Skenario B: Buat KK Baru
      data["family_id"] = null; // Kosongkan family_id
      data["custom_house_address"] = _addressController.text;
      
      // Mapping Ownership
      String ownerStatus = "other";
      if (_selectedOwnership == "Milik Sendiri") ownerStatus = "owner";
      else if (_selectedOwnership == "Sewa") ownerStatus = "renter";
      else if (_selectedOwnership == "Keluarga") ownerStatus = "family";
      data["ownership_status"] = ownerStatus;

    } else {
      // Skenario A: Masuk KK Lama
      data["family_id"] = int.tryParse(_selectedFamilyId ?? "0");
      // custom_house_address & ownership_status otomatis diabaikan backend
    }

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

  // --- UI HELPERS ---
  InputDecoration _inputDecor(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: primaryColor, width: 1.5)),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Container(width: 4, height: 18, color: primaryColor),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CitizenController>();

    return PageLayout(
      title: 'Tambah Warga',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 10),
                      Expanded(child: Text(controller.errorMessage!, style: const TextStyle(color: Colors.red))),
                    ],
                  ),
                ),

              // --- 1. TOGGLE MODE KELUARGA ---
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: SwitchListTile(
                  title: const Text("Buat Kartu Keluarga (KK) Baru?", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("Aktifkan jika warga ini adalah Kepala Keluarga baru"),
                  value: _isNewFamily,
                  activeColor: primaryColor,
                  onChanged: (val) {
                    setState(() {
                      _isNewFamily = val;
                      // Reset pilihan jika toggle berubah
                      _selectedFamilyId = null;
                      _addressController.clear();
                      _selectedOwnership = null;
                      // Auto set role jika buat KK baru
                      if(_isNewFamily) _selectedRole = "Kepala Keluarga";
                    });
                  },
                ),
              ),

              // --- 2. FORM KELUARGA (DINAMIS) ---
              _buildSectionHeader(_isNewFamily ? "Data Rumah & KK Baru" : "Pilih Keluarga Existing"),

              if (!_isNewFamily) 
                // A. MODE PILIH KELUARGA
                DropdownButtonFormField<String>(
                  decoration: _inputDecor("Pilih Keluarga", Icons.family_restroom),
                  value: _selectedFamilyId,
                  isExpanded: true,
                  items: controller.familyOptions.map<DropdownMenuItem<String>>((family) {
                    return DropdownMenuItem<String>(
                      value: family['id'].toString(),
                      child: Text(_getFamilyLabel(family), overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedFamilyId = val),
                  validator: (val) => !_isNewFamily && val == null ? "Wajib dipilih" : null,
                )
              else 
                // B. MODE BUAT RUMAH BARU
                Column(
                  children: [
                    TextFormField(
                      controller: _addressController,
                      decoration: _inputDecor("Alamat Rumah", Icons.home),
                      maxLines: 2,
                      validator: (val) => _isNewFamily && val!.isEmpty ? "Alamat wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: _inputDecor("Status Kepemilikan", Icons.verified_user),
                      value: _selectedOwnership,
                      items: ["Milik Sendiri", "Sewa", "Keluarga"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) => setState(() => _selectedOwnership = val),
                      validator: (val) => _isNewFamily && val == null ? "Wajib dipilih" : null,
                    ),
                  ],
                ),
              
              const SizedBox(height: 16),

              // --- 3. AKUN USER ---
              DropdownButtonFormField<String>(
                decoration: _inputDecor("Tautkan Akun User (Opsional)", Icons.link),
                value: _selectedUserId,
                isExpanded: true,
                hint: const Text("Pilih jika warga punya akun"),
                items: [
                  const DropdownMenuItem<String>(value: null, child: Text("Tidak menautkan akun", style: TextStyle(color: Colors.grey))),
                  ...controller.userOptions.map<DropdownMenuItem<String>>((user) {
                    return DropdownMenuItem<String>(
                      value: user['id'].toString(),
                      child: Text("${user['name']}", overflow: TextOverflow.ellipsis),
                    );
                  }),
                ],
                onChanged: (val) => setState(() => _selectedUserId = val),
              ),

              // --- 4. DATA DIRI ---
              _buildSectionHeader("Identitas Diri"),

              TextFormField(
                controller: _nameController,
                decoration: _inputDecor("Nama Lengkap", Icons.person),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nikController,
                keyboardType: TextInputType.number,
                decoration: _inputDecor("NIK (16 Digit)", Icons.badge),
                validator: (val) => val!.length < 16 ? "NIK minimal 16 digit" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecor("No. HP (Opsional)", Icons.phone_android),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _birthPlaceController,
                      decoration: _inputDecor("Tempat Lahir", Icons.location_city),
                      validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _birthDateController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: _inputDecor("Tgl Lahir", Icons.calendar_today),
                      validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
                    ),
                  ),
                ],
              ),

              _buildSectionHeader("Informasi Tambahan"),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: _inputDecor("Gender", Icons.wc),
                      value: _selectedGender,
                      items: ["Laki-laki", "Perempuan"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) => setState(() => _selectedGender = val),
                      validator: (val) => val == null ? "Wajib" : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: _inputDecor("Agama", Icons.mosque),
                      value: _selectedReligion,
                      items: ["Islam", "Kristen", "Katolik", "Hindu", "Budha", "Konghucu", "Lainnya"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) => setState(() => _selectedReligion = val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: _inputDecor("Peran dalam Keluarga", Icons.group),
                value: _selectedRole,
                items: ["Kepala Keluarga", "Istri", "Anak", "Lainnya"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _selectedRole = val),
                validator: (val) => val == null ? "Wajib dipilih" : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: _inputDecor("Pendidikan Terakhir", Icons.school),
                value: _selectedEducation,
                items: ["SD", "SMP", "SMA/SMK", "D3", "S1", "S2", "S3", "Tidak Sekolah", "Lainnya"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _selectedEducation = val),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: _inputDecor("Pekerjaan", Icons.work),
                value: _selectedOccupation,
                items: ["PNS", "Wiraswasta", "Swasta", "Pelajar/Mahasiswa", "Ibu Rumah Tangga", "Belum Bekerja", "Pensiunan", "Lainnya"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _selectedOccupation = val),
              ),
              
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: controller.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: controller.isLoading
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save),
                            SizedBox(width: 8),
                            Text("SIMPAN DATA WARGA", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}