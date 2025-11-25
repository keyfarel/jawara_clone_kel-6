import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

// Imports

import '../widgets/register_form.dart';

import '../../controllers/register_controller.dart';

import '../../data/models/register_request.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Warna Utama

  final Color primaryColor = const Color(0xFF1976D2);

  // Controllers

  final nameController = TextEditingController();

  final nikController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final customAddressController = TextEditingController();

  // State

  String? selectedGender;

  String? selectedHouseId;

  String? selectedOwnership;

  XFile? idCardPhoto;

  String _mapOwnershipStatus(String? uiValue) {
    switch (uiValue) {
      case "Milik Sendiri":
        return "owner";

      case "Sewa":
        return "rent";

      case "Keluarga":
        return "family";

      default:
        return "other";
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => idCardPhoto = pickedFile);
    }
  }

  void _handleRegister(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    if (idCardPhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon upload foto identitas")),
      );
      return;
    }

    final apiOwnershipStatus = _mapOwnershipStatus(selectedOwnership);

    final request = RegisterRequest(
      name: nameController.text,
      nik: nikController.text,
      email: emailController.text,
      phone: phoneController.text,
      password: passwordController.text,
      passwordConfirmation: confirmPasswordController.text,
      gender: selectedGender == "Laki-laki" ? "male" : "female",
      ownershipStatus: apiOwnershipStatus,
      houseId: selectedHouseId,
      customHouseAddress: customAddressController.text,
      idCardPhoto: idCardPhoto,
    );

    final controller = context.read<RegisterController>();
    final result = await controller.register(request);

    if (!mounted) return;

    if (result['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Registrasi Berhasil!"),
          backgroundColor: primaryColor,
        ),
      );

      // UBAH DISINI: Langsung ke Dashboard (Auto Login)
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/dashboard',
        (route) => false,
      );
    } else {
      String errorMessage = result['message'] ?? "Registrasi Gagal";

      if (result['errors'] != null) {
        // Handle validasi detail dari Laravel (misal: email taken)
        if (result['errors'] is Map) {
          final errors = result['errors'] as Map;
          final firstError = errors.values.first;
          if (firstError is List) {
            errorMessage = firstError.first;
          } else {
            errorMessage = firstError.toString();
          }
        } else {
          errorMessage += ": ${result['errors'].toString()}";
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RegisterController>();

    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F6FA,
      ), // Background abu-abu sangat muda

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [
                // Header Section
                const SizedBox(height: 10),

                Icon(Icons.home_work_rounded, size: 48, color: primaryColor),

                const SizedBox(height: 16),

                Text(
                  "Buat Akun Baru",

                  style: TextStyle(
                    fontSize: 24,

                    fontWeight: FontWeight.w800,

                    color: Colors.blueGrey.shade900,

                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Bergabunglah bersama warga lainnya",

                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 30),

                // Form Container (Card Style)
                Container(
                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(20),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),

                        blurRadius: 20,

                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),

                  child: Form(
                    key: _formKey,

                    child: Column(
                      children: [
                        RegisterForm(
                          nameController: nameController,

                          nikController: nikController,

                          emailController: emailController,

                          phoneController: phoneController,

                          passwordController: passwordController,

                          confirmPasswordController: confirmPasswordController,

                          customAddressController: customAddressController,

                          selectedGender: selectedGender,

                          selectedHouseId: selectedHouseId,

                          selectedOwnership: selectedOwnership,

                          selectedImage: idCardPhoto,

                          onGenderChanged: (val) =>
                              setState(() => selectedGender = val),

                          onHouseChanged: (val) =>
                              setState(() => selectedHouseId = val),

                          onOwnershipChanged: (val) =>
                              setState(() => selectedOwnership = val),

                          onPickImage: _pickImage,

                          primaryColor: primaryColor, // Pass warna ke form
                        ),

                        const SizedBox(height: 32),

                        // Modern Button
                        SizedBox(
                          width: double.infinity,

                          height: 54,

                          child: ElevatedButton(
                            onPressed: controller.isLoading
                                ? null
                                : () => _handleRegister(context),

                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,

                              elevation: 2,

                              shadowColor: primaryColor.withOpacity(0.4),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),

                            child: controller.isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,

                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "Daftar Sekarang",

                                    style: TextStyle(
                                      fontSize: 16,

                                      color: Colors.white,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Footer Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      "Sudah punya akun? ",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),

                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/login'),

                      child: Text(
                        "Masuk disini",

                        style: TextStyle(
                          fontWeight: FontWeight.bold,

                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
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
