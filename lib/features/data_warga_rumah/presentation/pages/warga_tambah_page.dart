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

  // --- 1. STATE UNTUK ERROR HANDLING ---
  // Default disabled, akan berubah jadi onUserInteraction setelah tombol simpan ditekan
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  // --- Controllers ---
  final _nameController = TextEditingController();
  final _nikController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _birthDateController = TextEditingController();
  
  // Controller Baru (Untuk Rumah Baru - Dipecah biar sama kayak Register)
  final _blockController = TextEditingController();
  final _numberController = TextEditingController();
  final _streetController = TextEditingController();

  // --- State Variables ---
  bool _isNewFamily = false; // False = Pilih Keluarga, True = Buat Baru
  
  String? _selectedFamilyId;
  String? _selectedUserId;
  String? _selectedGender;
  String? _selectedReligion;
  String? _selectedBloodType;
  String? _selectedRole;
  String? _selectedEducation;
  String? _selectedOccupation;
  String? _selectedStatus;
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
    // Dispose Controller Rumah Baru
    _blockController.dispose();
    _numberController.dispose();
    _streetController.dispose();
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

  // --- LOGIC UI: TOGGLE MODE ---
  void _toggleFamilyMode(bool isNew) {
    setState(() {
      _isNewFamily = isNew;
      // Reset logic agar data tidak tercampur dan UI bersih
      if (isNew) {
        _selectedFamilyId = null;
        _selectedRole = "Kepala Keluarga"; // Default jika buat KK baru
      } else {
        _blockController.clear();
        _numberController.clear();
        _streetController.clear();
        _selectedOwnership = null;
      }
    });
  }

  // --- LOGIC SUBMIT (UPDATED) ---
  void _submit() async {
    // 1. Cek Validasi Form
    if (!_formKey.currentState!.validate()) {
      // JIKA ERROR: Aktifkan mode auto validate
      // Agar saat user memperbaiki input, error langsung hilang (realtime)
      setState(() {
        _autoValidateMode = AutovalidateMode.onUserInteraction;
      });
      return;
    }

    // 2. Persiapan Data Base
    final data = {
      "user_id": _selectedUserId != null ? int.tryParse(_selectedUserId!) : null,
      "nik": _nikController.text,
      "name": _nameController.text,
      "phone": _phoneController.text.isEmpty ? null : _phoneController.text,
      "birth_place": _birthPlaceController.text,
      "birth_date": _birthDateController.text,
      "gender": _selectedGender == "Laki-laki" ? "male" : "female",
      "religion": _selectedReligion,
      "blood_type": (_selectedBloodType == "-") ? null : _selectedBloodType, 
      "education": _selectedEducation ?? "Lainnya",
      "occupation": _selectedOccupation ?? "Lainnya",
      "status": _selectedStatus == "Tidak Aktif" ? "inactive" : "active",
      "id_card_photo": null, 
    };

    // 3. Logic Role Mapping
    String roleToSend = "other";
    if (_selectedRole == "Kepala Keluarga") roleToSend = "head_of_family";
    else if (_selectedRole == "Istri") roleToSend = "wife";
    else if (_selectedRole == "Anak") roleToSend = "child";
    
    data["family_role"] = roleToSend;

    // 4. Logic Family / House
    if (_isNewFamily) {
      // Skenario B: Buat KK & Rumah Baru
      data["family_id"] = null;
      
      // Kirim Detail Rumah (Pecahan)
      data["house_block"] = _blockController.text;
      data["house_number"] = _numberController.text;
      data["house_street"] = _streetController.text;
      
      String ownerStatus = "other";
      if (_selectedOwnership == "Milik Sendiri") ownerStatus = "owner";
      else if (_selectedOwnership == "Sewa") ownerStatus = "renter";
      else if (_selectedOwnership == "Keluarga") ownerStatus = "family";
      data["ownership_status"] = ownerStatus;

    } else {
      // Skenario A: Masuk KK Lama
      data["family_id"] = int.tryParse(_selectedFamilyId ?? "0");
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
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1.5)),
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

  // Widget Tab Pilihan (Mirip Register)
  Widget _buildTabOption(String title, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : [],
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive ? primaryColor : Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ),
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
          // Mengaktifkan validasi otomatis SETELAH submit pertama kali gagal
          autovalidateMode: _autoValidateMode,
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

              // --- 1. PILIHAN KELUARGA (TAB STYLE) ---
              // Solusi bug UI: Menggunakan Tab container statis agar tidak lompat ukuran
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildTabOption("Masuk Keluarga Ada", !_isNewFamily, () => _toggleFamilyMode(false)),
                    _buildTabOption("Buat KK Baru", _isNewFamily, () => _toggleFamilyMode(true)),
                  ],
                ),
              ),

              // --- 2. FORM KELUARGA (DINAMIS) ---
              
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
                // B. MODE BUAT RUMAH BARU (DIPECAH 3 FIELD - Mirip Register)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Alamat Rumah Baru", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _blockController,
                              decoration: _inputDecor("Blok", Icons.domain),
                              validator: (val) => _isNewFamily && val!.isEmpty ? "Wajib" : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _numberController,
                              decoration: _inputDecor("Nomor", Icons.format_list_numbered),
                              keyboardType: TextInputType.number,
                              validator: (val) => _isNewFamily && val!.isEmpty ? "Wajib" : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _streetController,
                        decoration: _inputDecor("Jalan / RT RW", Icons.add_road),
                        validator: (val) => _isNewFamily && val!.isEmpty ? "Wajib" : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        decoration: _inputDecor("Status Kepemilikan", Icons.verified_user),
                        value: _selectedOwnership,
                        items: ["Milik Sendiri", "Sewa", "Keluarga"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (val) => setState(() => _selectedOwnership = val),
                        validator: (val) => _isNewFamily && val == null ? "Wajib dipilih" : null,
                      ),
                    ],
                  ),
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
                decoration: _inputDecor("Golongan Darah", Icons.bloodtype),
                value: _selectedBloodType,
                items: ["A", "B", "AB", "O", "-"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _selectedBloodType = val),
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