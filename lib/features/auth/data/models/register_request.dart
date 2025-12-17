// lib/data/models/register_request.dart
import 'package:image_picker/image_picker.dart';

class RegisterRequest {
  // ... field lama (name, nik, dll) ...
  final String name;
  final String nik;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final String gender;
  final String ownershipStatus;
  
  final String birthPlace;
  final String birthDate;
  final String religion;
  final String? bloodType;
  final String education;
  final String occupation;
  final String familyRole;

  final String? houseId; // Jika pilih rumah yg ada
  
  // --- JADI INI (Data Rumah Baru) ---
  final String? houseBlock;
  final String? houseNumber;
  final String? houseStreet; // Nama Jalan / RT RW
  
  final XFile? selfiePhoto;
  final XFile? idCardPhoto;

  RegisterRequest({
    required this.name,
    required this.nik,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    required this.gender,
    required this.ownershipStatus,
    required this.birthPlace,
    required this.birthDate,
    required this.religion,
    this.bloodType,
    required this.education,
    required this.occupation,
    this.familyRole = "Kepala Keluarga",
    
    this.houseId,
    // Update Constructor
    this.houseBlock,
    this.houseNumber,
    this.houseStreet,
    
    this.idCardPhoto,
    this.selfiePhoto,
  });
}