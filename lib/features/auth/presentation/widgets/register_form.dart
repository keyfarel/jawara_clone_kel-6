import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController nikController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController customAddressController;

  final String? selectedGender;
  final String? selectedHouseId;
  final String? selectedOwnership;
  final XFile? selectedImage;

  final Function(String?) onGenderChanged;
  final Function(String?) onHouseChanged;
  final Function(String?) onOwnershipChanged;
  final VoidCallback onPickImage;
  
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
    required this.onGenderChanged,
    required this.onHouseChanged,
    required this.onOwnershipChanged,
    required this.onPickImage,
    required this.primaryColor,
    this.selectedGender,
    this.selectedHouseId,
    this.selectedOwnership,
    this.selectedImage,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Data Pribadi"),
        _ModernTextField(
          controller: widget.nameController,
          hint: "Nama Lengkap",
          icon: Icons.person_outline,
          validator: (val) => val!.isEmpty ? "Nama wajib diisi" : null,
          primaryColor: widget.primaryColor,
        ),
        const SizedBox(height: 16),
        _ModernTextField(
          controller: widget.nikController,
          hint: "NIK",
          icon: Icons.badge_outlined,
          inputType: TextInputType.number,
          validator: (val) => val!.isEmpty ? "NIK wajib diisi" : null,
          primaryColor: widget.primaryColor,
        ),
        const SizedBox(height: 16),
        _ModernDropdown(
          value: widget.selectedGender,
          hint: "Jenis Kelamin",
          icon: Icons.wc,
          items: const ["Laki-laki", "Perempuan"],
          onChanged: widget.onGenderChanged,
          primaryColor: widget.primaryColor,
        ),
        
        const SizedBox(height: 24),
        _buildSectionTitle("Kontak & Akun"),
        _ModernTextField(
          controller: widget.emailController,
          hint: "Email",
          icon: Icons.email_outlined,
          inputType: TextInputType.emailAddress,
          validator: (val) => val!.isEmpty ? "Email wajib diisi" : null,
          primaryColor: widget.primaryColor,
        ),
        const SizedBox(height: 16),
        _ModernTextField(
          controller: widget.phoneController,
          hint: "No. Telepon / WA",
          icon: Icons.phone_android_outlined,
          inputType: TextInputType.phone,
          validator: (val) => val!.isEmpty ? "Nomor wajib diisi" : null,
          primaryColor: widget.primaryColor,
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: widget.passwordController,
          obscureText: _isPasswordHidden,
          validator: (val) => val!.isEmpty ? "Password wajib diisi" : null,
          style: const TextStyle(fontSize: 15),
          decoration: _modernInputDecoration(
            "Kata Sandi", 
            Icons.lock_outline, 
            widget.primaryColor,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordHidden = !_isPasswordHidden;
                });
              },
            ),
          ),
        ),

        const SizedBox(height: 16),
        
        TextFormField(
          controller: widget.confirmPasswordController,
          obscureText: _isConfirmPasswordHidden,
          validator: (val) {
             if (val!.isEmpty) return "Konfirmasi password wajib diisi";
             if (val != widget.passwordController.text) return "Password tidak sama";
             return null;
          },
          style: const TextStyle(fontSize: 15),
          decoration: _modernInputDecoration(
            "Ulangi Kata Sandi", 
            Icons.lock_reset_outlined, 
            widget.primaryColor,
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordHidden ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
                });
              },
            ),
          ),
        ),

        const SizedBox(height: 24),
        _buildSectionTitle("Tempat Tinggal"),
        
        DropdownButtonFormField<String>(
          value: widget.selectedHouseId,
          isExpanded: true,
          decoration: _modernInputDecoration(
            "Pilih Rumah (Opsional)", 
            Icons.home_outlined, 
            widget.primaryColor
          ),
          items: const [
            DropdownMenuItem(value: "1", child: Text("Blok A1")),
            DropdownMenuItem(value: "2", child: Text("Blok B2")),
          ],
          onChanged: widget.onHouseChanged,
        ),
        
        const SizedBox(height: 16),
        
        _ModernTextField(
          controller: widget.customAddressController,
          hint: "Alamat Manual (Opsional)",
          icon: Icons.add_location_alt_outlined,
          primaryColor: widget.primaryColor,
        ),
        
        const SizedBox(height: 16),
        _ModernDropdown(
          value: widget.selectedOwnership,
          hint: "Status Kepemilikan",
          icon: Icons.verified_user_outlined,
          items: const ["Milik Sendiri", "Sewa", "Keluarga"],
          onChanged: widget.onOwnershipChanged,
          primaryColor: widget.primaryColor,
        ),

        const SizedBox(height: 24),
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
                  )
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

InputDecoration _modernInputDecoration(String hint, IconData icon, Color color, {Widget? suffixIcon}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
    prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 22),
    suffixIcon: suffixIcon, 
    filled: true,
    fillColor: Colors.grey.shade50, 
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none, 
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade200),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red.shade200),
    ),
  );
}

class _ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType inputType;
  final String? Function(String?)? validator;
  final Color primaryColor;

  const _ModernTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.primaryColor,
    this.inputType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: validator,
      style: const TextStyle(fontSize: 15),
      decoration: _modernInputDecoration(hint, icon, primaryColor),
    );
  }
}

class _ModernDropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final IconData icon;
  final List<String> items;
  final Function(String?) onChanged;
  final Color primaryColor;

  const _ModernDropdown({
    required this.value,
    required this.hint,
    required this.icon,
    required this.items,
    required this.onChanged,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      decoration: _modernInputDecoration(hint, icon, primaryColor),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item, style: const TextStyle(fontSize: 15)),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (val) => val == null ? "$hint wajib dipilih" : null,
    );
  }
}