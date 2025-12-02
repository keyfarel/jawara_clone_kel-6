class ChannelModel {
  final int id;
  final String channelName;
  final String type;
  final String accountNumber;
  final String accountName;
  final String? thumbnail;
  final String? qrCode;
  final String? notes;
  final bool isActive;

  ChannelModel({
    required this.id,
    required this.channelName,
    required this.type,
    required this.accountNumber,
    required this.accountName,
    this.thumbnail,
    this.qrCode,
    this.notes,
    required this.isActive,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'],
      channelName: json['channel_name'] ?? 'Tanpa Nama',
      type: json['type'] ?? 'General',
      accountNumber: json['account_number'] ?? '-',
      accountName: json['account_name'] ?? '-',
      thumbnail: json['thumbnail'],
      qrCode: json['qr_code'],
      notes: json['notes'],
      isActive: json['is_active'] ?? false,
    );
  }
}