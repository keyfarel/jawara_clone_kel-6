// lib/features/data_warga_rumah/data/models/citizen_model.dart

class CitizenModel {
  final int id;
  final String nik;
  final String name;
  final String phone;
  final String gender; // male/female
  final String status; // active, inactive, permanent, moved
  final String? idCardPhoto;
  final String familyRole;
  final String? birthDate;
  final String? birthPlace;
  final String? religion;
  final String? bloodType;
  
  // Field Baru
  final String? education;
  final String? occupation;

  // Nested Data
  final String? address; // family -> house -> address
  final String? houseName; // family -> house -> house_name

  CitizenModel({
    required this.id,
    required this.nik,
    required this.name,
    required this.phone,
    required this.gender,
    required this.status,
    this.idCardPhoto,
    required this.familyRole,
    this.birthDate,
    this.birthPlace,
    this.religion,
    this.bloodType,
    this.education,
    this.occupation,
    this.address,
    this.houseName,
  });

  factory CitizenModel.fromJson(Map<String, dynamic> json) {
    // Navigasi nested object untuk ambil alamat
    String? addr;
    String? hName;
    
    if (json['family'] != null && json['family']['house'] != null) {
      addr = json['family']['house']['address'];
      hName = json['family']['house']['house_name'];
    }

    return CitizenModel(
      id: json['id'],
      nik: json['nik'] ?? '-',
      name: json['name'] ?? 'Tanpa Nama',
      phone: json['phone'] ?? '-',
      gender: json['gender'] ?? 'male',
      status: json['status'] ?? 'active',
      idCardPhoto: json['id_card_photo'],
      familyRole: json['family_role'] ?? 'Anggota',
      birthDate: json['birth_date'],
      birthPlace: json['birth_place'],
      religion: json['religion'],
      bloodType: json['blood_type'],
      
      // Mapping field baru
      education: json['education'],
      occupation: json['occupation'],
      
      address: addr ?? 'Alamat tidak tersedia',
      houseName: hName ?? '-',
    );
  }
}