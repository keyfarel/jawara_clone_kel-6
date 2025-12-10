import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// Import file custom input yang baru dibuat
import 'custom_inputs.dart';

class RegisterForm extends StatefulWidget {
  // Semua parameter tetap sama, hanya FocusNode saya siapkan opsional
  final TextEditingController nameController;
  final TextEditingController nikController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController customAddressController;

  final FocusNode? nameFocus;
  final FocusNode? nikFocus;
  final FocusNode? emailFocus;
  final FocusNode? phoneFocus;
  final FocusNode? passwordFocus;
  final FocusNode? confirmPasswordFocus;
  final FocusNode? customAddressFocus;

  final String? selectedGender;
  final String? selectedHouseId;
  final String? selectedOwnership;
  final XFile? selectedImage;
  final XFile? selectedSelfie; 
  final VoidCallback onPickSelfie;
  
  final Function(String?) onGenderChanged;
  final Function(String?) onHouseChanged;
  final Function(String?) onOwnershipChanged;
  final VoidCallback onPickImage;
  
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
    
    this.nameFocus,
    this.nikFocus,
    this.emailFocus,
    this.phoneFocus,
    this.passwordFocus,
    this.confirmPasswordFocus,
    this.customAddressFocus,

    required this.onGenderChanged,
    required this.onHouseChanged,
    required this.onOwnershipChanged,
    required this.onPickImage,
    required this.primaryColor,
    required this.houseOptions,
    
    this.selectedGender,
    this.selectedHouseId,
    this.selectedOwnership,
    this.selectedImage,
    this.selectedSelfie,
    required this.onPickSelfie,
    this.isLoadingHouses = false,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  // State password hidden sudah pindah ke ModernPasswordField!
  
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

  // --- BAGIAN 1: DATA PRIBADI ---
  Widget _buildPersonalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Data Pribadi"),
        ModernTextField(
          controller: widget.nameController,
          focusNode: widget.nameFocus,
          hint: "Nama Lengkap",
          icon: Icons.person_outline,
          validator: (val) => val!.isEmpty ? "Nama wajib diisi" : null,
          primaryColor: widget.primaryColor,
        ),
        const SizedBox(height: 16),
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
        ModernDropdown(
          value: widget.selectedGender,
          hint: "Jenis Kelamin",
          icon: Icons.wc,
          items: const ["Laki-laki", "Perempuan"],
          onChanged: widget.onGenderChanged,
          primaryColor: widget.primaryColor,
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
        // Menggunakan ModernPasswordField baru
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
            if (val != widget.passwordController.text) return "Password tidak sama";
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
        DropdownButtonFormField<String>(
          value: widget.selectedHouseId,
          isExpanded: true,
          hint: widget.isLoadingHouses
              ? const Text("Memuat data rumah...", style: TextStyle(fontSize: 14))
              : const Text("Pilih Rumah (Opsional)"),
          decoration: modernInputDecoration( // Panggil dari custom_inputs
            "Pilih Rumah",
            Icons.home_outlined,
            widget.primaryColor,
          ),
          onChanged: (widget.isLoadingHouses || widget.houseOptions.isEmpty)
              ? null
              : widget.onHouseChanged,
          items: widget.houseOptions.map<DropdownMenuItem<String>>((house) {
            return DropdownMenuItem<String>(
              value: house['id'].toString(),
              child: Text(house['house_name'], style: const TextStyle(fontSize: 15)),
            );
          }).toList(),
        ),
        
        if (!widget.isLoadingHouses && widget.houseOptions.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 5),
            child: Text(
              "Tidak ada rumah kosong. Silakan isi alamat manual.",
              style: TextStyle(color: Colors.orange.shade800, fontSize: 12),
            ),
          ),

        const SizedBox(height: 16),
        ModernTextField(
          controller: widget.customAddressController,
          focusNode: widget.customAddressFocus,
          hint: "Alamat Manual (Opsional)",
          icon: Icons.add_location_alt_outlined,
          primaryColor: widget.primaryColor,
        ),
        const SizedBox(height: 16),
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
        _buildSectionTitle("Foto Identitas"),
        InkWell(
          onTap: widget.onPickImage,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: widget.selectedImage != null ? Colors.green.shade50 : Colors.grey.shade50,
              border: Border.all(
                color: widget.selectedImage != null ? Colors.green : Colors.grey.shade300,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  widget.selectedImage != null ? Icons.check_circle : Icons.cloud_upload_outlined,
                  size: 32,
                  color: widget.selectedImage != null ? Colors.green : widget.primaryColor,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.selectedImage != null ? "Foto Terpilih" : "Upload KTP",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.selectedImage != null ? Colors.green.shade700 : Colors.grey.shade700,
                  ),
                ),
                if (widget.selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      widget.selectedImage!.name,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelfieSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Verifikasi Wajah"),
        InkWell(
          onTap: widget.onPickSelfie,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              // Warna beda dikit biar kelihatan ini step penting
              color: widget.selectedSelfie != null ? Colors.blue.shade50 : Colors.grey.shade50,
              border: Border.all(
                color: widget.selectedSelfie != null ? Colors.blue : Colors.grey.shade300,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  widget.selectedSelfie != null ? Icons.face_retouching_natural : Icons.camera_front,
                  size: 32,
                  color: widget.selectedSelfie != null ? Colors.blue : widget.primaryColor,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.selectedSelfie != null ? "Selfie Tersimpan" : "Ambil Selfie",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.selectedSelfie != null ? Colors.blue.shade700 : Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                if (widget.selectedSelfie == null)
                  const Text(
                    "Wajib menggunakan kamera depan",
                    style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
                  )
                else
                  Text(
                    "Siap Verifikasi",
                    style: TextStyle(fontSize: 11, color: Colors.blue.shade700),
                  ),
              ],
            ),
          ),
        ),
      ],
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