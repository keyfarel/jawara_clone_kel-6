import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// Imports Components
import '../widgets/register/register_form.dart';
import '../widgets/register/register_header.dart'; // Import Baru
import '../widgets/register/register_footer.dart'; // Import Baru

// Imports Logic & Data
import '../../controllers/register_controller.dart';
import '../../data/models/register_request.dart';
import '../../data/auth_repository.dart';
import '../../data/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final Color primaryColor = const Color(0xFF1976D2);

  // --- 1. CONTROLLERS ---
  final nameController = TextEditingController();
  final nikController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final customAddressController = TextEditingController();

  // --- 2. FOCUS NODES (Untuk Auto Focus Error) ---
  final nameFocus = FocusNode();
  final nikFocus = FocusNode();
  final emailFocus = FocusNode();
  final phoneFocus = FocusNode();
  final passwordFocus = FocusNode();
  final confirmPasswordFocus = FocusNode();
  final customAddressFocus = FocusNode();

  // --- 3. STATE VARIABLES ---
  String? selectedGender;
  String? selectedHouseId;
  String? selectedOwnership;
  XFile? idCardPhoto;

  List<dynamic> _houseOptions = [];
  bool _isLoadingHouses = true;

  final AuthRepository _authRepository = AuthRepository(AuthService());

  // --- 4. LIFECYCLE ---
  @override
  void initState() {
    super.initState();
    _fetchHouses();
  }

  @override
  void dispose() {
    // Bersihkan semua controller & focus node
    nameController.dispose();
    nikController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    customAddressController.dispose();

    nameFocus.dispose();
    nikFocus.dispose();
    emailFocus.dispose();
    phoneFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    customAddressFocus.dispose();
    super.dispose();
  }

  // --- 5. LOGIC METHODS ---
  Future<void> _fetchHouses() async {
    try {
      final houses = await _authRepository.getHouseOptions();
      if (mounted) {
        setState(() {
          _houseOptions = houses;
          _isLoadingHouses = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingHouses = false);
    }
  }

  void _requestFocusOnError(Map<String, dynamic> errors) {
    if (errors.containsKey('name') || errors.containsKey('full_name')) {
      nameFocus.requestFocus();
    } else if (errors.containsKey('nik')) {
      nikFocus.requestFocus();
    } else if (errors.containsKey('email')) {
      emailFocus.requestFocus();
    } else if (errors.containsKey('phone')) {
      phoneFocus.requestFocus();
    } else if (errors.containsKey('password')) {
      passwordFocus.requestFocus();
    } else if (errors.containsKey('custom_house_address')) {
      customAddressFocus.requestFocus();
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) setState(() => idCardPhoto = pickedFile);
  }

  // --- 6. SUBMIT HANDLER ---
  // --- 6. SUBMIT HANDLER ---
  void _handleRegister(BuildContext context) async {
    // 1. VALIDASI CLIENT SIDE (Field Kosong/Format Salah)
    if (!_formKey.currentState!.validate()) {
      // Logika Manual: Cari field pertama yang kosong/invalid lalu fokus
      if (nameController.text.isEmpty) {
        nameFocus.requestFocus();
      } else if (nikController.text.isEmpty) {
        nikFocus.requestFocus();
      } else if (selectedGender == null) {
        // Dropdown biasanya tidak punya focus node, tapi kita bisa scroll ke atas
        // atau biarkan user melihatnya.
      } else if (emailController.text.isEmpty ||
          !emailController.text.contains('@')) {
        emailFocus.requestFocus();
      } else if (phoneController.text.isEmpty) {
        phoneFocus.requestFocus();
      } else if (passwordController.text.isEmpty) {
        passwordFocus.requestFocus();
      } else if (confirmPasswordController.text.isEmpty) {
        confirmPasswordFocus.requestFocus();
      } else if (selectedHouseId == null &&
          customAddressController.text.isEmpty) {
        // Jika rumah belum dipilih DAN alamat manual kosong
        customAddressFocus.requestFocus();
      }
      return; // Stop proses
    }

    if (idCardPhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon upload foto identitas")),
      );
      return;
    }

    // Mapping Status
    String ownership = "owner"; // Default

    if (selectedOwnership == "Milik Sendiri") {
      ownership = "owner";
    } else if (selectedOwnership == "Sewa") {
      ownership =
          "renter"; // PERBAIKAN: Jangan "rent", harus "renter" sesuai DB
    } else if (selectedOwnership == "Keluarga") {
      ownership = "family"; // PERBAIKAN: Sesuai enum baru
    }

    final request = RegisterRequest(
      name: nameController.text,
      nik: nikController.text,
      email: emailController.text,
      phone: phoneController.text,
      password: passwordController.text,
      passwordConfirmation: confirmPasswordController.text,
      gender: selectedGender == "Laki-laki" ? "male" : "female",
      ownershipStatus: ownership,
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
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/dashboard',
        (route) => false,
      );
    } else {
      // 2. VALIDASI SERVER SIDE (Email sudah terpakai, dll)
      String errorMessage = result['message'] ?? "Registrasi Gagal";

      if (result['errors'] != null && result['errors'] is Map) {
        final errors = result['errors'] as Map<String, dynamic>;

        // Panggil fungsi Auto Focus Server Side
        _requestFocusOnError(errors);

        final firstError = errors.values.first;
        errorMessage = (firstError is List)
            ? firstError.first
            : firstError.toString();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  // --- 7. UI BUILD ---
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RegisterController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // 1. Header Widget
                RegisterHeader(primaryColor: primaryColor),

                // 2. Form Container
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
                          // Data
                          houseOptions: _houseOptions,
                          isLoadingHouses: _isLoadingHouses,
                          primaryColor: primaryColor,

                          // Controllers
                          nameController: nameController,
                          nikController: nikController,
                          emailController: emailController,
                          phoneController: phoneController,
                          passwordController: passwordController,
                          confirmPasswordController: confirmPasswordController,
                          customAddressController: customAddressController,

                          // Focus Nodes (Passing ke Widget Form)
                          nameFocus: nameFocus,
                          nikFocus: nikFocus,
                          emailFocus: emailFocus,
                          phoneFocus: phoneFocus,
                          passwordFocus: passwordFocus,
                          confirmPasswordFocus: confirmPasswordFocus,
                          customAddressFocus: customAddressFocus,

                          // State & Callbacks
                          selectedGender: selectedGender,
                          selectedHouseId: selectedHouseId,
                          selectedOwnership: selectedOwnership,
                          selectedImage: idCardPhoto,

                          onGenderChanged: (val) =>
                              setState(() => selectedGender = val),
                          onHouseChanged: (val) {
                            setState(() {
                              selectedHouseId = val;
                              if (val != null) customAddressController.clear();
                            });
                          },
                          onOwnershipChanged: (val) =>
                              setState(() => selectedOwnership = val),
                          onPickImage: _pickImage,
                        ),

                        const SizedBox(height: 32),

                        // Tombol Daftar
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: controller.isLoading
                                ? null
                                : () => _handleRegister(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 2,
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

                // 3. Footer Widget
                RegisterFooter(
                  primaryColor: primaryColor,
                  onLoginTap: () => Navigator.pushNamed(context, '/login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
