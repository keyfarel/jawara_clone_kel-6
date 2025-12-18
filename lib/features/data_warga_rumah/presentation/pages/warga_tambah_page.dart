import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/layouts/pages_layout.dart';
import '../../controllers/citizen_controller.dart';
import '../../../dashboard/controllers/dashboard_controller.dart';

class TambahWargaPage extends StatefulWidget {
  const TambahWargaPage({super.key});

  @override
  State<TambahWargaPage> createState() => _TambahWargaPageState();
}

class _TambahWargaPageState extends State<TambahWargaPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  // --- Controllers ---
  final _nameController = TextEditingController();
  final _nikController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _birthDateController = TextEditingController();

  // --- State Variables ---
  String? _selectedFamilyId;
  String? _selectedUserId;
  String? _selectedGender;
  String? _selectedReligion;
  String? _selectedBloodType;
  String? _selectedRole;
  String? _selectedEducation;
  String? _selectedOccupation;
  String? _selectedStatus = "active"; // Default Active

  // --- Logic Data Titipan (Locked Fields) ---
  String? _prefilledFamilyId; // Jika tidak null, dropdown keluarga dikunci
  String? _lockedRole; // Jika tidak null, dropdown peran dikunci

  final Color primaryColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CitizenController>().loadInitialData();
    });
  }

  // --- MENGAMBIL ARGUMEN DARI NAVIGATOR ---
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cek apakah ada data yang dikirim dari halaman Tambah Keluarga
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args != null && args is Map<String, dynamic>) {
      // Set data titipan
      if (args['family_id'] != null) {
        _prefilledFamilyId = args['family_id'].toString();
        _selectedFamilyId = _prefilledFamilyId; // Set value awal
      }
      if (args['family_role'] != null) {
        _lockedRole = args['family_role'].toString();
        _selectedRole = _lockedRole; // Set value awal (misal: Kepala Keluarga)
      }
    }
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
    String name = family['family_name'] ?? '';
    String kk = family['kk_number'] ?? '';

    // Jika Nama sama dengan No KK (artinya belum ada Kepala Keluarga)
    if (name == kk) {
      return "KK: $kk";
    }

    // Jika Nama ada (sudah ada Kepala Keluarga)
    return "$name - $kk";
  }

  // --- LOGIC SUBMIT (SIMPLIFIED) ---
  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _autoValidateMode = AutovalidateMode.onUserInteraction;
      });
      return;
    }

    // 1. Persiapan Data
    final data = {
      "user_id": _selectedUserId != null
          ? int.tryParse(_selectedUserId!)
          : null,
      "family_id": int.tryParse(_selectedFamilyId!), // Pasti ada karena wajib
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
      // "id_card_photo": null, // Handle upload foto terpisah jika ada
    };

    // 2. Logic Role Mapping
    String roleToSend = "other";
    if (_selectedRole == "Kepala Keluarga")
      roleToSend = "head_of_family";
    else if (_selectedRole == "Istri")
      roleToSend = "wife";
    else if (_selectedRole == "Anak")
      roleToSend = "child";

    data["family_role"] = roleToSend;

    // 3. Kirim ke Controller
    final controller = context.read<CitizenController>();
    final success = await controller.addCitizen(data);

    if (mounted) {
      if (success) {
        // Refresh Dashboard Stats
        context.read<DashboardController>().refreshData();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Berhasil menambah data warga!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.errorMessage ?? "Gagal menyimpan"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // --- UI Helpers ---
  InputDecoration _inputDecor(
    String label,
    IconData icon, {
    bool filled = true,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: filled,
      fillColor: filled ? Colors.grey.shade50 : Colors.transparent,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      disabledBorder: OutlineInputBorder(
        // Style untuk field terkunci
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Container(width: 4, height: 18, color: primaryColor),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CitizenController>();
    final isFamilyLocked = _prefilledFamilyId != null; // Cek status kunci
    final isRoleLocked = _lockedRole != null; // Cek status kunci

    return PageLayout(
      title: 'Tambah Warga',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidateMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Error Message
              if (controller.errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    controller.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // --- 1. KELUARGA (Locked/Unlocked) ---
              // Jika locked (titipan), background jadi agak abu-abu dan tidak bisa diklik
              Container(
                decoration: isFamilyLocked
                    ? BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      )
                    : null,
                child: DropdownButtonFormField<String>(
                  decoration: _inputDecor(
                    "Pilih Keluarga",
                    Icons.family_restroom,
                    filled: !isFamilyLocked,
                  ),
                  value: _selectedFamilyId,
                  isExpanded: true,
                  // Jika locked, items kosong atau null onchanged
                  items: controller.familyOptions.map<DropdownMenuItem<String>>(
                    (family) {
                      return DropdownMenuItem<String>(
                        value: family['id'].toString(),
                        child: Text(
                          _getFamilyLabel(family),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ).toList(),
                  // LOGIC KUNCI: Jika locked, onChanged = null (disable dropdown)
                  onChanged: isFamilyLocked
                      ? null
                      : (val) => setState(() => _selectedFamilyId = val),
                  validator: (val) => val == null ? "Wajib dipilih" : null,
                ),
              ),

              if (isFamilyLocked)
                const Padding(
                  padding: EdgeInsets.only(top: 6, left: 12, bottom: 12),
                  child: Text(
                    "*Otomatis terpilih dari KK yang baru dibuat.",
                    style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                  ),
                )
              else
                const SizedBox(height: 16),

              // --- 2. PERAN (Locked/Unlocked) ---
              Container(
                decoration: isRoleLocked
                    ? BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      )
                    : null,
                child: DropdownButtonFormField<String>(
                  decoration: _inputDecor(
                    "Peran dalam Keluarga",
                    Icons.group,
                    filled: !isRoleLocked,
                  ),
                  value: _selectedRole,
                  items: ["Kepala Keluarga", "Istri", "Anak", "Lainnya"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  // LOGIC KUNCI: Jika locked, onChanged = null
                  onChanged: isRoleLocked
                      ? null
                      : (val) => setState(() => _selectedRole = val),
                  validator: (val) => val == null ? "Wajib dipilih" : null,
                ),
              ),
              const SizedBox(height: 16),

              // --- 3. IDENTITAS DIRI ---
              _buildSectionHeader("Identitas Diri"),

              TextFormField(
                controller: _nameController,
                decoration: _inputDecor("Nama Lengkap", Icons.person),
                textCapitalization: TextCapitalization.words,
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nikController,
                keyboardType: TextInputType.number,
                decoration: _inputDecor("NIK (16 Digit)", Icons.badge),
                validator: (val) {
                  if (val == null || val.isEmpty) return "Wajib diisi";
                  if (val.length < 16) return "NIK minimal 16 digit";
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _birthPlaceController,
                      decoration: _inputDecor(
                        "Tempat Lahir",
                        Icons.location_city,
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _birthDateController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: _inputDecor(
                        "Tgl Lahir",
                        Icons.calendar_today,
                      ),
                      validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: _inputDecor("Jenis Kelamin", Icons.wc),
                value: _selectedGender,
                items: ["Laki-laki", "Perempuan"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedGender = val),
                validator: (val) => val == null ? "Wajib dipilih" : null,
              ),

              const SizedBox(height: 16),
              _buildSectionHeader("Informasi Tambahan"),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: _inputDecor("Agama", Icons.mosque),
                      value: _selectedReligion,
                      items:
                          [
                                "Islam",
                                "Kristen",
                                "Katolik",
                                "Hindu",
                                "Budha",
                                "Konghucu",
                                "Lainnya",
                              ]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedReligion = val),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: _inputDecor(
                        "Golongan Darah",
                        Icons.bloodtype,
                      ),
                      value: _selectedBloodType,
                      items: ["A", "B", "AB", "O", "-"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedBloodType = val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: _inputDecor("Pekerjaan", Icons.work),
                value: _selectedOccupation,
                items:
                    [
                          "PNS",
                          "Wiraswasta",
                          "Swasta",
                          "Pelajar/Mahasiswa",
                          "Ibu Rumah Tangga",
                          "Belum Bekerja",
                          "Pensiunan",
                          "Lainnya",
                        ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) => setState(() => _selectedOccupation = val),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: _inputDecor("Pendidikan Terakhir", Icons.school),
                value: _selectedEducation,
                items:
                    [
                          "SD",
                          "SMP",
                          "SMA/SMK",
                          "D3",
                          "S1",
                          "S2",
                          "S3",
                          "Tidak Sekolah",
                        ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) => setState(() => _selectedEducation = val),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save),
                            SizedBox(width: 8),
                            Text(
                              "SIMPAN DATA WARGA",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
