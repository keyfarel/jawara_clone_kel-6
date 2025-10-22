import 'package:flutter/material.dart';
import 'package:myapp/models/pengguna_model.dart';
import '../../../layouts/pages_layout.dart';

class TambahPenggunaPage extends StatefulWidget {
  const TambahPenggunaPage({super.key});

  @override
  State<TambahPenggunaPage> createState() => _TambahPenggunaPageState();
}

class _TambahPenggunaPageState extends State<TambahPenggunaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController hpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController konfirmasiPasswordController = TextEditingController();

  String? selectedRole;

  final List<String> roles = ['Admin', 'Petugas', 'Warga'];

  void resetForm() {
    _formKey.currentState?.reset();
    namaController.clear();
    emailController.clear();
    hpController.clear();
    passwordController.clear();
    konfirmasiPasswordController.clear();
    setState(() => selectedRole = null);
  }

  void simpanData() {
    if (_formKey.currentState?.validate() ?? false) {
      final pengguna = PenggunaModel(
        namaLengkap: namaController.text,
        email: emailController.text,
        nomorHp: hpController.text,
        password: passwordController.text,
        role: selectedRole ?? '-',
      );

      // Simulasi simpan (bisa disambung ke backend)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data ${pengguna.namaLengkap} berhasil disimpan!'),
          backgroundColor: Colors.indigoAccent,
        ),
      );

      resetForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Tambah Akun Pengguna',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextField(
                    controller: namaController,
                    label: 'Nama Lengkap',
                    hint: 'Masukkan nama lengkap',
                    icon: Icons.person,
                    validator: (value) =>
                    value!.isEmpty ? 'Nama lengkap wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    controller: emailController,
                    label: 'Email',
                    hint: 'Masukkan email aktif',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) return 'Email wajib diisi';
                      if (!value.contains('@')) return 'Format email tidak valid';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    controller: hpController,
                    label: 'Nomor HP',
                    hint: 'Masukkan nomor HP (cth: 08xxxxxxxxxx)',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                    value!.isEmpty ? 'Nomor HP wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    controller: passwordController,
                    label: 'Password',
                    hint: 'Masukkan password',
                    icon: Icons.lock,
                    obscureText: true,
                    validator: (value) =>
                    value!.length < 6 ? 'Minimal 6 karakter' : null,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    controller: konfirmasiPasswordController,
                    label: 'Konfirmasi Password',
                    hint: 'Masukkan ulang password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) return 'Konfirmasi password wajib diisi';
                      if (value != passwordController.text) {
                        return 'Password tidak sama';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // === DROPDOWN ROLE ===
                  Text(
                    'Role',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.indigoAccent.shade700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: InputDecoration(
                      hintText: '-- Pilih Role --',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    items: roles
                        .map((role) => DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    ))
                        .toList(),
                    onChanged: (value) => setState(() => selectedRole = value),
                    validator: (value) =>
                    value == null ? 'Role harus dipilih' : null,
                  ),
                  const SizedBox(height: 24),

                  // === BUTTONS ===
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: simpanData,
                          icon: const Icon(Icons.save),
                          label: const Text('Simpan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigoAccent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: resetForm,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.indigoAccent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Colors.indigoAccent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // === Helper Widget TextField ===
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.indigoAccent.shade700,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.indigoAccent),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }
}
