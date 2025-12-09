class ChannelModel {
  final int id;
  final String channelName;
  final String type;
  final String accountNumber; // Mungkin null di list, tapi ada di detail
  final String accountName;
  final String? thumbnailUrl; // Ganti thumbnail jadi thumbnailUrl
  final String? qrCodeUrl;    // Ganti qrCode jadi qrCodeUrl
  final String? notes;
  final bool isActive;

  ChannelModel({
    required this.id,
    required this.channelName,
    required this.type,
    required this.accountNumber,
    required this.accountName,
    this.thumbnailUrl,
    this.qrCodeUrl,
    this.notes,
    required this.isActive,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'],
      channelName: json['channel_name'] ?? 'Tanpa Nama',
      type: json['type'] ?? 'General',
      // Di list mungkin tidak dikirim, kasih default '-'
      accountNumber: json['account_number'] ?? '-', 
      accountName: json['account_name'] ?? '-',
      // Perhatikan key JSON dari backend: thumbnail_url & qr_code_url
      thumbnailUrl: json['thumbnail_url'], 
      qrCodeUrl: json['qr_code_url'],
      notes: json['notes'],
      isActive: json['is_active'] ?? true, // Default true jika null
    );
  }
}