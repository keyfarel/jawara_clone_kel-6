import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/layouts/pages_layout.dart';
import '../../controllers/user_controller.dart';

class TambahPenggunaPage extends StatefulWidget {
  const TambahPenggunaPage({super.key});

  @override
  State<TambahPenggunaPage> createState() => _TambahPenggunaPageState();
}

class _TambahPenggunaPageState extends State<TambahPenggunaPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // State
  String? selectedRole;
  bool _isPasswordVisible = false;

  // Opsi Role (Sesuaikan dengan backend)
  final List<String> roles = ['admin', 'resident', 'treasurer'];

  @override
  Widget build(BuildContext context) {
    // Watch loading state dari controller
    final isLoading = context.select<UserController, bool>((c) => c.isLoading);

    return PageLayout(
      title: "Tambah Pengguna",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shadowColor: Colors.grey.withOpacity(0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Informasi Akun",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nama Lengkap
                  _buildLabel("Nama Lengkap"),
                  TextFormField(
                    controller: nameController,
                    decoration: _inputDecoration("Contoh: Budi Santoso", Icons.person_outline),
                    validator: (val) => val!.isEmpty ? "Nama wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),

                  // Email
                  _buildLabel("Alamat Email"),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration("Contoh: budi@email.com", Icons.email_outlined),
                    validator: (val) => !val!.contains("@") ? "Email tidak valid" : null,
                  ),
                  const SizedBox(height: 16),

                  // No HP
                  _buildLabel("Nomor Telepon / WA"),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _inputDecoration("Contoh: 08123456789", Icons.phone_android_outlined),
                    validator: (val) => val!.isEmpty ? "Nomor telepon wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),

                  // Role Dropdown
                  _buildLabel("Peran (Role)"),
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: _inputDecoration("Pilih Peran", Icons.admin_panel_settings_outlined),
                    items: roles.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role[0].toUpperCase() + role.substring(1)), // Capitalize
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => selectedRole = val),
                    validator: (val) => val == null ? "Peran wajib dipilih" : null,
                  ),
                  const SizedBox(height: 16),

                  // Password
                  _buildLabel("Password"),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: _inputDecoration("Masukkan password", Icons.lock_outline).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (val) => val!.length < 6 ? "Password minimal 6 karakter" : null,
                  ),
                  const SizedBox(height: 32),

                  // Tombol Simpan
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        disabledBackgroundColor: Colors.grey.shade300,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text(
                              "Simpan Pengguna",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final controller = context.read<UserController>();

      final isSuccess = await controller.addUser(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        password: passwordController.text,
        role: selectedRole!,
      );

      if (!mounted) return;

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pengguna berhasil ditambahkan"), backgroundColor: Colors.green),
        );
        Navigator.pop(context); // Kembali ke daftar
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.errorMessage ?? "Gagal menambahkan pengguna"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey.shade400),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
      ),
    );
  }
}
