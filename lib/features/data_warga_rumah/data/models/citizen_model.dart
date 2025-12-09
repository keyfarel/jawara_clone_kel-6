class CitizenModel {
  final int id;
  final String nik;
  final String name;
  final String phone;
  final String gender; // male/female
  final String status; // permanent, moved
  final String? idCardPhoto;
  final String familyRole;
  final String? birthDate;
  final String? birthPlace;
  final String? religion;
  final String? bloodType;
  
  // Nested Data
  final String? address; // Diambil dari family -> house -> address
  final String? houseName; // Diambil dari family -> house -> house_name

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
      status: json['status'] ?? 'permanent',
      idCardPhoto: json['id_card_photo'],
      familyRole: json['family_role'] ?? 'Anggota',
      birthDate: json['birth_date'],
      birthPlace: json['birth_place'],
      religion: json['religion'],
      bloodType: json['blood_type'],
      address: addr ?? 'Alamat tidak tersedia',
      houseName: hName ?? '-',
    );
  }
}