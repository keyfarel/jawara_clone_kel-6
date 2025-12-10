// lib/features/keluarga/data/models/keluarga_model.dart

import 'dart:convert';

// --- Model Utama (Keluarga) ---

class KeluargaModel {
  final int id;
  final int houseId;
  final String? kkNumber;
  final String ownershipStatus;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final HouseModel house;
  final List<CitizenModel> citizens;

  KeluargaModel({
    required this.id,
    required this.houseId,
    this.kkNumber,
    required this.ownershipStatus,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.house,
    required this.citizens,
  });

  factory KeluargaModel.fromJson(Map<String, dynamic> json) {
    return KeluargaModel(
      id: json['id'],
      houseId: json['house_id'],
      kkNumber: json.containsKey('kk_number') && json['kk_number'] != null
          ? json['kk_number'] as String
          : null,
      ownershipStatus: json['ownership_status'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      house: HouseModel.fromJson(json['house']),
      citizens: (json['citizens'] as List)
          .map((i) => CitizenModel.fromJson(i))
          .toList(),
    );
  }

  // Helper untuk mendapatkan Kepala Keluarga (Citizen dengan family_role "Kepala Keluarga")
  CitizenModel? get kepalaKeluarga {
    try {
      return citizens.firstWhere((c) => c.familyRole == "Kepala Keluarga");
    } catch (e) {
      return null; // Return null jika tidak ditemukan
    }
  }
}

// --- Model Pendukung (House) ---

class HouseModel {
  final int id;
  final String houseName;
  final String ownerName;
  final String address;
  final String houseType;
  final int hasCompleteFacilities;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  HouseModel({
    required this.id,
    required this.houseName,
    required this.ownerName,
    required this.address,
    required this.houseType,
    required this.hasCompleteFacilities,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HouseModel.fromJson(Map<String, dynamic> json) {
    return HouseModel(
      id: json['id'],
      houseName: json['house_name'],
      ownerName: json['owner_name'],
      address: json['address'],
      houseType: json['house_type'],
      hasCompleteFacilities: json['has_complete_facilities'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

// --- Model Pendukung (Citizen) ---

class CitizenModel {
  final int id;
  final int familyId;
  final int? userId;
  final String nik;
  final String name;
  final String phone;
  final String? birthPlace;
  final String? birthDate;
  final String gender;
  final String? religion;
  final String? bloodType;
  final String? idCardPhoto;
  final String? verifiedSelfiePhoto;
  final String familyRole;
  final String? education;
  final String? occupation;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  CitizenModel({
    required this.id,
    required this.familyId,
    this.userId,
    required this.nik,
    required this.name,
    required this.phone,
    this.birthPlace,
    this.birthDate,
    required this.gender,
    this.religion,
    this.bloodType,
    this.idCardPhoto,
    this.verifiedSelfiePhoto,
    required this.familyRole,
    this.education,
    this.occupation,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CitizenModel.fromJson(Map<String, dynamic> json) {
    return CitizenModel(
      id: json['id'],
      familyId: json['family_id'],
      userId: json.containsKey('user_id') && json['user_id'] != null
          ? json['user_id'] as int
          : null,
      nik: json['nik'],
      name: json['name'],
      phone: json['phone'],
      birthPlace: json['birth_place'],
      birthDate: json['birth_date'],
      gender: json['gender'],
      religion: json['religion'],
      bloodType: json['blood_type'],
      idCardPhoto: json['id_card_photo'],
      verifiedSelfiePhoto: json['verified_selfie_photo'],
      familyRole: json['family_role'],
      education: json['education'],
      occupation: json['occupation'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

// --- List Model untuk Top Level Response ---

class ListKeluargaModel {
  final List<KeluargaModel> families;

  ListKeluargaModel({required this.families});

  factory ListKeluargaModel.fromListJson(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    final families = jsonList.map((i) => KeluargaModel.fromJson(i)).toList();
    return ListKeluargaModel(families: families);
  }
}