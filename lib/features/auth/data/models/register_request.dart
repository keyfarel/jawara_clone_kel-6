import 'package:image_picker/image_picker.dart';

class RegisterRequest {
  final String name;
  final String nik;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final String gender;
  final String ownershipStatus;
  final String? houseId;
  final String? customHouseAddress;

  final XFile? idCardPhoto; // Ganti File → XFile (AMAN untuk Web & Android)

  RegisterRequest({
    required this.name,
    required this.nik,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    required this.gender,
    required this.ownershipStatus,
    this.houseId,
    this.customHouseAddress,
    this.idCardPhoto,
  });
}
