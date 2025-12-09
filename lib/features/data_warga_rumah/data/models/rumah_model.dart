class RumahModel {
  final int id;
  final String houseName;
  final String ownerName;
  final String address;
  final String status; // occupied, empty, etc
  final String houseType;
  final bool hasCompleteFacilities;

  RumahModel({
    required this.id,
    required this.houseName,
    required this.ownerName,
    required this.address,
    required this.status,
    required this.houseType,
    required this.hasCompleteFacilities,
  });

  factory RumahModel.fromJson(Map<String, dynamic> json) {
    return RumahModel(
      id: json['id'],
      houseName: json['house_name'] ?? 'Rumah Tanpa Nama',
      ownerName: json['owner_name'] ?? '-',
      address: json['address'] ?? '-',
      status: json['status'] ?? 'unknown',
      houseType: json['house_type'] ?? '-',
      hasCompleteFacilities: (json['has_complete_facilities'] == 1),
    );
  }

  // Helper untuk Status Bahasa Indonesia
  String get statusDisplay {
    if (status == 'occupied') return 'Ditempati';
    if (status == 'empty') return 'Tersedia';
    return status; // Default
  }
}