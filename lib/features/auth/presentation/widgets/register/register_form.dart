import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// Pastikan path ini sesuai dengan lokasi file custom_inputs.dart Anda
import 'custom_inputs.dart';

class RegisterForm extends StatefulWidget {
  // --- EXISTING CONTROLLERS ---
  final TextEditingController nameController;
  final TextEditingController nikController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController customAddressController;
  final TextEditingController blockController;
  final TextEditingController numberController;
  final TextEditingController streetController;

  // --- NEW CONTROLLERS (KEPENDUDUKAN) ---
  final TextEditingController birthPlaceController;
  final TextEditingController birthDateController;

  // --- FOCUS NODES ---
  final FocusNode? nameFocus;
  final FocusNode? nikFocus;
  final FocusNode? emailFocus;
  final FocusNode? phoneFocus;
  final FocusNode? passwordFocus;
  final FocusNode? confirmPasswordFocus;
  final FocusNode? customAddressFocus;
  final FocusNode? blockFocus;
  final FocusNode? numberFocus;
  final FocusNode? streetFocus;

  // --- STATE DATA ---
  final String? selectedGender;
  final String? selectedHouseId;
  final String? selectedOwnership;
  final String? selectedReligion; // Baru
  final String? selectedBloodType; // Baru
  final String? selectedEducation;
  final String? selectedOccupation;
  final bool isNewHouseMode;
  final Function(bool) onToggleHouseMode;

  // CALLBACK BARU
  final XFile? selectedImage;
  final XFile? selectedSelfie;

  // --- CALLBACKS ---
  final Function(String?) onGenderChanged;
  final Function(String?) onHouseChanged;
  final Function(String?) onOwnershipChanged;
  final Function(String?) onReligionChanged; // Baru
  final Function(String?) onBloodTypeChanged; // Baru
  final Function(String?) onEducationChanged;
  final Function(String?) onOccupationChanged;

  final VoidCallback onPickImage;
  final VoidCallback onPickSelfie;
  final VoidCallback onDateTap; // Baru (untuk DatePicker)
  final VoidCallback onRemoveImage;
  final VoidCallback onRemoveSelfie;

  // --- CONFIG ---
  final List<dynamic> houseOptions;
  final bool isLoadingHouses;
  final Color primaryColor;

  const RegisterForm({
    super.key,
    required this.nameController,
    required this.nikController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.customAddressController,

    // Wajib ditambahkan di constructor agar tidak error di Parent
    required this.birthPlaceController,
    required this.birthDateController,

    this.nameFocus,
    this.nikFocus,
    this.emailFocus,
    this.phoneFocus,
    this.passwordFocus,
    this.confirmPasswordFocus,
    this.customAddressFocus,
    this.blockFocus,
    this.numberFocus,
    this.streetFocus,
    required this.blockController,
    required this.numberController,
    required this.streetController,
    required this.onGenderChanged,
    required this.onHouseChanged,
    required this.onOwnershipChanged,
    required this.onReligionChanged, // Baru
    required this.onBloodTypeChanged, // Baru
    required this.onPickImage,
    required this.onPickSelfie,
    required this.onDateTap, // Baru
    required this.onRemoveImage, // Wajib diisi
    required this.onRemoveSelfie, // Wajib diisi
    required this.selectedEducation,
    required this.selectedOccupation,
    required this.onEducationChanged,
    required this.onOccupationChanged,

    required this.primaryColor,
    required this.houseOptions,

    this.selectedGender,
    this.selectedHouseId,
    this.selectedOwnership,
    this.selectedReligion, // Baru
    this.selectedBloodType, // Baru
    this.selectedImage,
    this.selectedSelfie,
    required this.isNewHouseMode,
    required this.onToggleHouseMode,
    this.isLoadingHouses = false,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPersonalSection(),
        const SizedBox(height: 24),
        _buildAccountSection(),
        const SizedBox(height: 24),
        _buildResidenceSection(),
        const SizedBox(height: 24),
        _buildPhotoSection(),
        const SizedBox(height: 24),
        _buildSelfieSection(),
      ],
    );
  }

  // --- BAGIAN 1: DATA PRIBADI (UPDATED) ---
  Widget _buildPersonalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Data Pribadi"),

        // Nama
        ModernTextField(
          controller: widget.nameController,
          focusNode: widget.nameFocus,
          hint: "Nama Lengkap",
          icon: Icons.person_outline,
          validator: (val) => val!.isEmpty ? "Nama wajib diisi" : null,
          primaryColor: widget.primaryColor,
        ),
        const SizedBox(height: 16),

        // NIK
        ModernTextField(
          controller: widget.nikController,
          focusNode: widget.nikFocus,
          hint: "NIK",
          icon: Icons.badge_outlined,
          inputType: TextInputType.number,
          validator: (val) => val!.isEmpty ? "NIK wajib diisi" : null,
          primaryColor: widget.primaryColor,
        ),
        const SizedBox(height: 16),

        // Gender
        ModernDropdown(
          value: widget.selectedGender,
          hint: "Jenis Kelamin",
          icon: Icons.wc,
          items: const ["Laki-laki", "Perempuan"],
          onChanged: widget.onGenderChanged,
          primaryColor: widget.primaryColor,
        ),
        const SizedBox(height: 16),

        // --- BARIS 1: Tempat & Tanggal Lahir ---
        Row(
          children: [
            Expanded(
              child: ModernTextField(
                controller: widget.birthPlaceController,
                hint: "Tempat Lahir",
                icon: Icons.location_city,
                primaryColor: widget.primaryColor,
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ModernTextField(
                controller: widget.birthDateController,
                hint: "Tgl Lahir",
                icon: Icons.calendar_today,
                primaryColor: widget.primaryColor,
                readOnly: true,
                onTap: widget.onDateTap,
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: ModernDropdown(
                value: widget.selectedEducation,
                hint: "Pendidikan Terakhir",
                icon: Icons.school_outlined,
                items: const [
                  "SD",
                  "SMP",
                  "SMA/SMK",
                  "D3",
                  "S1",
                  "S2",
                  "S3",
                  "Tidak Sekolah",
                  "Lainnya",
                ],
                onChanged: widget.onEducationChanged,
                primaryColor: widget.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ModernDropdown(
                value: widget.selectedOccupation,
                hint: "Pekerjaan",
                icon: Icons.work_outline,
                items: const [
                  "PNS",
                  "Wiraswasta",
                  "Swasta",
                  "Pelajar/Mahasiswa",
                  "Ibu Rumah Tangga",
                  "Belum Bekerja",
                  "Pensiunan",
                  "Lainnya",
                ],
                onChanged: widget.onOccupationChanged,
                primaryColor: widget.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // --- BARIS 2: Agama & Golongan Darah ---
        Row(
          children: [
            Expanded(
              child: ModernDropdown(
                value: widget.selectedReligion,
                hint: "Agama",
                icon: Icons.mosque, // Icon universal bisa disesuaikan
                items: const [
                  "Islam",
                  "Kristen",
                  "Katolik",
                  "Hindu",
                  "Budha",
                  "Konghucu",
                ],
                onChanged: widget.onReligionChanged,
                primaryColor: widget.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ModernDropdown(
                value: widget.selectedBloodType,
                hint: "Gol. Darah",
                icon: Icons.bloodtype,
                items: const ["A", "B", "AB", "O", "-"],
                onChanged: widget.onBloodTypeChanged,
                primaryColor: widget.primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- BAGIAN 2: KONTAK & AKUN ---
  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Kontak & Akun"),
        ModernTextField(
          controller: widget.emailController,
          focusNode: widget.emailFocus,
          hint: "Email",
          icon: Icons.email_outlined,
          inputType: TextInputType.emailAddress,
          validator: (val) => val!.isEmpty ? "Email wajib diisi" : null,
          primaryColor: widget.primaryColor,
        ),
        const SizedBox(height: 16),
        ModernTextField(
          controller: widget.phoneController,
          focusNode: widget.phoneFocus,
          hint: "No. Telepon / WA",
          icon: Icons.phone_android_outlined,
          inputType: TextInputType.phone,
          validator: (val) => val!.isEmpty ? "Nomor wajib diisi" : null,
          primaryColor: widget.primaryColor,
        ),
        const SizedBox(height: 16),
        ModernPasswordField(
          controller: widget.passwordController,
          focusNode: widget.passwordFocus,
          hint: "Kata Sandi",
          primaryColor: widget.primaryColor,
          validator: (val) => val!.isEmpty ? "Password wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        ModernPasswordField(
          controller: widget.confirmPasswordController,
          focusNode: widget.confirmPasswordFocus,
          hint: "Ulangi Kata Sandi",
          primaryColor: widget.primaryColor,
          validator: (val) {
            if (val!.isEmpty) return "Konfirmasi password wajib diisi";
            if (val != widget.passwordController.text)
              return "Password tidak sama";
            return null;
          },
        ),
      ],
    );
  }

  // --- BAGIAN 3: TEMPAT TINGGAL ---
Widget _buildResidenceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Tempat Tinggal"),
        
        // 1. TOGGLE SWITCH (Pilih Rumah vs Buat Baru)
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _buildTabOption("Pilih Rumah", !widget.isNewHouseMode, () => widget.onToggleHouseMode(false)),
              _buildTabOption("Buat Baru", widget.isNewHouseMode, () => widget.onToggleHouseMode(true)),
            ],
          ),
        ),

        // 2. KONTEN DINAMIS BERDASARKAN MODE
        if (!widget.isNewHouseMode)
          // MODE A: PILIH RUMAH
          Column(
            children: [
              DropdownButtonFormField<String>(
                value: widget.selectedHouseId,
                isExpanded: true,
                hint: widget.isLoadingHouses
                    ? const Text("Memuat data...", style: TextStyle(fontSize: 14))
                    : const Text("Pilih Rumah dari List"),
                decoration: modernInputDecoration("Pilih Rumah", Icons.home_outlined, widget.primaryColor),
                onChanged: widget.onHouseChanged,
                items: widget.houseOptions.map<DropdownMenuItem<String>>((house) {
                  return DropdownMenuItem<String>(
                    value: house['id'].toString(),
                    child: Text(house['house_name'], style: const TextStyle(fontSize: 15)),
                  );
                }).toList(),
              ),
              if (widget.houseOptions.isEmpty && !widget.isLoadingHouses)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text("Belum ada data rumah. Silakan buat baru.", style: TextStyle(color: Colors.orange.shade800, fontSize: 12)),
                ),
            ],
          )
        else
          // MODE B: BUAT RUMAH BARU
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
                Row(
                  children: [
                    Expanded(
                      child: ModernTextField(
                        controller: widget.blockController,
                        focusNode: widget.blockFocus,
                        hint: "Blok (A)",
                        icon: Icons.domain,
                        primaryColor: widget.primaryColor,
                        validator: (val) => widget.isNewHouseMode && val!.isEmpty ? "Wajib" : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ModernTextField(
                        controller: widget.numberController,
                        focusNode: widget.numberFocus,
                        hint: "Nomor (12)",
                        icon: Icons.format_list_numbered,
                        inputType: TextInputType.number,
                        primaryColor: widget.primaryColor,
                        validator: (val) => widget.isNewHouseMode && val!.isEmpty ? "Wajib" : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ModernTextField(
                  controller: widget.streetController,
                  focusNode: widget.streetFocus,
                  hint: "Nama Jalan / RT RW",
                  icon: Icons.add_road,
                  primaryColor: widget.primaryColor,
                  validator: (val) => widget.isNewHouseMode && val!.isEmpty ? "Wajib" : null,
                ),
              ],
            ),
          ),

        const SizedBox(height: 16),
        
        // Status Kepemilikan (Selalu muncul karena relevan untuk kedua mode)
        ModernDropdown(
          value: widget.selectedOwnership,
          hint: "Status Kepemilikan",
          icon: Icons.verified_user_outlined,
          items: const ["Milik Sendiri", "Sewa", "Keluarga"],
          onChanged: widget.onOwnershipChanged,
          primaryColor: widget.primaryColor,
        ),
      ],
    );
  }
  // --- BAGIAN 4: FOTO IDENTITAS ---
  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Foto Identitas (Opsional)"), // Update Judul

        if (widget.selectedImage != null)
          _buildSelectedFileCard(
            fileName: widget.selectedImage!.name,
            iconColor: Colors.green,
            label: "Foto Terpilih",
            onRemove: widget.onRemoveImage,
          )
        else
          InkWell(
            onTap: widget.onPickImage,
            borderRadius: BorderRadius.circular(12),
            child: _buildPlaceholderCard(
              icon: Icons.cloud_upload_outlined,
              label: "Upload KTP",
              color: widget.primaryColor,
              subText: "Boleh dikosongkan", // Tambahkan keterangan
            ),
          ),
      ],
    );
  }

  // --- BAGIAN 5: SELFIE (UPDATED) ---
  Widget _buildSelfieSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Verifikasi Wajah (Opsional)"), // Update Judul

        if (widget.selectedSelfie != null)
          _buildSelectedFileCard(
            fileName: "Selfie berhasil diambil",
            iconColor: Colors.blue,
            label: "Selfie Tersimpan",
            onRemove: widget.onRemoveSelfie,
          )
        else
          InkWell(
            onTap: widget.onPickSelfie,
            borderRadius: BorderRadius.circular(12),
            child: _buildPlaceholderCard(
              icon: Icons.camera_front,
              label: "Ambil Selfie",
              color: widget.primaryColor,
              subText:
                  "Disarankan untuk verifikasi lebih cepat", // Ubah text wajib
            ),
          ),
      ],
    );
  }

  // --- WIDGET HELPER BARU: Tampilan File Terpilih ---
  Widget _buildSelectedFileCard({
    required String fileName,
    required Color iconColor,
    required String label,
    required VoidCallback onRemove,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.05),
        border: Border.all(color: iconColor, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 28, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  fileName,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // TOMBOL HAPUS (SILANG MERAH)
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            tooltip: "Hapus Foto",
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER BARU: Tampilan Placeholder (Belum Upload) ---
  Widget _buildPlaceholderCard({
    required IconData icon,
    required String label,
    required Color color,
    String? subText,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          if (subText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                subText,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabOption(String title, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
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
              color: isActive ? widget.primaryColor : Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade500,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
