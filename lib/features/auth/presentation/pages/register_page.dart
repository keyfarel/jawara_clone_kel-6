import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// Imports Components
import '../widgets/register/register_form.dart';
import '../widgets/register/register_header.dart';
import '../widgets/register/register_footer.dart';

// Imports Logic & Data
import '../../controllers/register_controller.dart';
import '../../data/models/register_request.dart';
import '../../data/auth_repository.dart';
import '../../data/auth_service.dart';
import '../../../data_warga_rumah/controllers/citizen_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final Color primaryColor = const Color(0xFF1976D2);
  bool isNewHouseMode = false;

  // --- 1. CONTROLLERS ---
  final nameController = TextEditingController();
  final nikController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final customAddressController = TextEditingController();
  final blockController = TextEditingController();
  final numberController = TextEditingController();
  final streetController = TextEditingController();

  // Controller Baru (Kependudukan)
  final birthPlaceController = TextEditingController();
  final birthDateController = TextEditingController();

  // --- 2. FOCUS NODES ---
  final nameFocus = FocusNode();
  final nikFocus = FocusNode();
  final emailFocus = FocusNode();
  final phoneFocus = FocusNode();
  final passwordFocus = FocusNode();
  final confirmPasswordFocus = FocusNode();
  final customAddressFocus = FocusNode();
  final blockFocus = FocusNode();
  final numberFocus = FocusNode();
  final streetFocus = FocusNode();

  // --- 3. STATE VARIABLES ---
  String? selectedGender;
  String? selectedHouseId;
  String? selectedOwnership;
  String? selectedEducation;
  String? selectedOccupation;

  // State Baru (Dropdown)
  String? selectedReligion;
  String? selectedBloodType;

  XFile? idCardPhoto;
  XFile? selfiePhoto;

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
    nameController.dispose();
    nikController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    customAddressController.dispose();

    // Dispose yang baru
    birthPlaceController.dispose();
    birthDateController.dispose();

    nameFocus.dispose();
    nikFocus.dispose();
    emailFocus.dispose();
    phoneFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    customAddressFocus.dispose();
    blockController.dispose();
    numberController.dispose();
    streetController.dispose();

    blockFocus.dispose();
    numberFocus.dispose();
    streetFocus.dispose();
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

    if (errors.containsKey('house_block')) {
      blockFocus.requestFocus();
    } else if (errors.containsKey('house_number')) {
      numberFocus.requestFocus();
    } else if (errors.containsKey('house_street')) {
      streetFocus.requestFocus();
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
      maxWidth: 1024,
    );
    if (pickedFile != null) setState(() => idCardPhoto = pickedFile);
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
        birthDateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _pickSelfie() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 50,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      setState(() => selfiePhoto = pickedFile);
    }
  }

  // --- 6. SUBMIT HANDLER ---
  void _handleRegister(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);
      if (nameController.text.isEmpty)
        nameFocus.requestFocus();
      else if (nikController.text.isEmpty)
        nikFocus.requestFocus();
      else if (emailController.text.isEmpty)
        emailFocus.requestFocus();
      else if (phoneController.text.isEmpty)
        phoneFocus.requestFocus();
      else if (passwordController.text.isEmpty)
        passwordFocus.requestFocus();
      else if (confirmPasswordController.text.isEmpty)
        confirmPasswordFocus.requestFocus();
      else if (selectedHouseId == null &&
          customAddressController.text.isEmpty) {
        customAddressFocus.requestFocus();
      }

      if (selectedHouseId == null) {
        if (blockController.text.isEmpty)
          blockFocus.requestFocus();
        else if (numberController.text.isEmpty)
          numberFocus.requestFocus();
        else if (streetController.text.isEmpty)
          streetFocus.requestFocus();
      }

      if (isNewHouseMode) {
        if (blockController.text.isEmpty)
          blockFocus.requestFocus();
        else if (numberController.text.isEmpty)
          numberFocus.requestFocus();
        else if (streetController.text.isEmpty)
          streetFocus.requestFocus();
      }
      return;
    }

    if (selectedHouseId == null) {
      if (blockController.text.isEmpty ||
          numberController.text.isEmpty ||
          streetController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Jika membuat rumah baru, mohon lengkapi Blok, Nomor, dan Jalan.",
            ),
          ),
        );
        return;
      }
    }

    if (!isNewHouseMode && selectedHouseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silakan pilih rumah atau ganti ke mode 'Buat Baru'."),
        ),
      );
      return;
    }

    if (birthPlaceController.text.isEmpty ||
        birthDateController.text.isEmpty ||
        selectedReligion == null ||
        selectedEducation == null || // Cek Education
        selectedOccupation ==
            null // Cek Occupation
            ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Mohon lengkapi data kependudukan (Lahir, Agama, Pendidikan, Pekerjaan)",
          ),
        ),
      );
      return;
    }

    // Validasi Data Kependudukan
    if (birthPlaceController.text.isEmpty ||
        birthDateController.text.isEmpty ||
        selectedReligion == null ||
        selectedBloodType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Mohon lengkapi data kependudukan (Lahir, Agama, Gol. Darah)",
          ),
        ),
      );
      return;
    }

    String ownership = "owner";
    if (selectedOwnership == "Sewa")
      ownership = "renter";
    else if (selectedOwnership == "Keluarga")
      ownership = "family";

    final request = RegisterRequest(
      name: nameController.text,
      nik: nikController.text,
      email: emailController.text,
      phone: phoneController.text,
      password: passwordController.text,
      passwordConfirmation: confirmPasswordController.text,
      gender: selectedGender == "Laki-laki" ? "male" : "female",
      ownershipStatus: ownership,
      idCardPhoto: idCardPhoto,
      selfiePhoto: selfiePhoto,
      houseId: (!isNewHouseMode) ? selectedHouseId : null,

      // Kirim Data Baru
      birthPlace: birthPlaceController.text,
      birthDate: birthDateController.text,
      religion: selectedReligion!,
      bloodType: (selectedBloodType == "-") ? null : selectedBloodType,
      education: selectedEducation!,
      occupation: selectedOccupation!,
      houseBlock: (selectedHouseId == null) ? blockController.text : null,
      houseNumber: (selectedHouseId == null) ? numberController.text : null,
      houseStreet: (selectedHouseId == null) ? streetController.text : null,
    );

    final controller = context.read<RegisterController>();
    final result = await controller.register(request);

    if (!mounted) return;

    if (result['status'] == 'success') {
      try {
        // force: true artinya hiraukan cache, ambil baru dari API
        await context.read<CitizenController>().loadCitizens(force: true);
      } catch (e) {
        // Catch error jaga-jaga jika CitizenController belum di-provide di tree (jarang terjadi)
        print("Gagal refresh citizen list: $e");
      }
      // --------------------------------

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
      String errorMessage = result['message'] ?? "Registrasi Gagal";

      if (result['errors'] != null && result['errors'] is Map) {
        final errors = result['errors'] as Map<String, dynamic>;
        _requestFocusOnError(errors);

        if (errors.containsKey('selfie_photo')) {
          final errList = errors['selfie_photo'] as List;
          errorMessage = errList.first;
        } else {
          final firstError = errors.values.first;
          errorMessage = (firstError is List)
              ? firstError.first
              : firstError.toString();
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  void _removeImage() {
    setState(() {
      idCardPhoto = null;
    });
  }

  void _removeSelfie() {
    setState(() {
      selfiePhoto = null;
    });
  }

  void _toggleHouseMode(bool isNew) {
    setState(() {
      isNewHouseMode = isNew;

      // RESET LOGIC
      if (isNew) {
        // Jika pindah ke Buat Baru -> Reset Pilihan Dropdown
        selectedHouseId = null;
      } else {
        // Jika pindah ke Pilih Rumah -> Reset Form Manual
        blockController.clear();
        numberController.clear();
        streetController.clear();
      }
    });
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
                RegisterHeader(primaryColor: primaryColor),

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
                    autovalidateMode: _autoValidateMode,
                    child: Column(
                      children: [
                        RegisterForm(
                          // Controllers Lama
                          nameController: nameController,
                          nikController: nikController,
                          emailController: emailController,
                          phoneController: phoneController,
                          passwordController: passwordController,
                          confirmPasswordController: confirmPasswordController,
                          customAddressController: customAddressController,
                          blockController: blockController,
                          numberController: numberController,
                          streetController: streetController,

                          blockFocus: blockFocus,
                          numberFocus: numberFocus,
                          streetFocus: streetFocus,

                          // Controllers Baru
                          birthPlaceController: birthPlaceController,
                          birthDateController: birthDateController,

                          // Focus Nodes
                          nameFocus: nameFocus,
                          nikFocus: nikFocus,
                          emailFocus: emailFocus,
                          phoneFocus: phoneFocus,
                          passwordFocus: passwordFocus,
                          confirmPasswordFocus: confirmPasswordFocus,
                          customAddressFocus: customAddressFocus,

                          // Data State
                          houseOptions: _houseOptions,
                          isLoadingHouses: _isLoadingHouses,
                          primaryColor: primaryColor,

                          selectedGender: selectedGender,
                          selectedHouseId: selectedHouseId,
                          selectedOwnership: selectedOwnership,

                          // State Baru
                          selectedReligion: selectedReligion,
                          selectedBloodType: selectedBloodType,
                          selectedEducation: selectedEducation,
                          selectedOccupation: selectedOccupation,

                          onEducationChanged: (val) =>
                              setState(() => selectedEducation = val),
                          onOccupationChanged: (val) =>
                              setState(() => selectedOccupation = val),
                          selectedImage: idCardPhoto,
                          selectedSelfie: selfiePhoto,
                          onRemoveImage: _removeImage,
                          onRemoveSelfie: _removeSelfie,
                          isNewHouseMode: isNewHouseMode,
                          onToggleHouseMode: _toggleHouseMode,

                          // Callbacks
                          onGenderChanged: (val) =>
                              setState(() => selectedGender = val),
                          onHouseChanged: (val) {
                            setState(() {
                              selectedHouseId = val;
                              // Jika user memilih rumah, kita bisa kosongkan form manual
                              if (val != null) {
                                blockController.clear();
                                numberController.clear();
                                streetController.clear();
                              }
                            });
                          },
                          onOwnershipChanged: (val) =>
                              setState(() => selectedOwnership = val),

                          // Callback Baru
                          onReligionChanged: (val) =>
                              setState(() => selectedReligion = val),
                          onBloodTypeChanged: (val) =>
                              setState(() => selectedBloodType = val),
                          onDateTap: () => _selectDate(context),

                          onPickImage: _pickImage,
                          onPickSelfie: _pickSelfie,
                        ),

                        const SizedBox(height: 32),

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
