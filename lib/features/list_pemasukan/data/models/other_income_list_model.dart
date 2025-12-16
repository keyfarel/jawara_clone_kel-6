class OtherIncomeListResponse {
  final bool success;
  final String message;
  final List<OtherIncomeItemModel> data;

  OtherIncomeListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OtherIncomeListResponse.fromJson(Map<String, dynamic> json) {
    return OtherIncomeListResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => OtherIncomeItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class OtherIncomeItemModel {
  final int id;
  final String title;
  final double amount;
  final DateTime transactionDate;
  final String? description;
  final DateTime createdAt;
  final OtherIncomeCategoryModel category;
  // **PERBAIKAN 1: Tambahkan properti proofImageLink**
  final String? proofImageLink; 

  OtherIncomeItemModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.transactionDate,
    this.description,
    required this.createdAt,
    required this.category,
    // Tambahkan ke constructor
    this.proofImageLink, 
  });

  factory OtherIncomeItemModel.fromJson(Map<String, dynamic> json) {
    // Mengkonversi string amount (e.g., "120000.00") ke double
    final amountString = json['amount'] as String? ?? '0.0';
    final parsedAmount = double.tryParse(amountString) ?? 0.0;
    
    // Parsing tanggal
    final transactionDateStr = json['transaction_date'] as String? ?? '';
    final createdAtStr = json['created_at'] as String? ?? '';

    return OtherIncomeItemModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Tidak Bertajuk',
      amount: parsedAmount,
      transactionDate: DateTime.tryParse(transactionDateStr) ?? DateTime.now(),
      description: json['description'] as String?,
      createdAt: DateTime.tryParse(createdAtStr) ?? DateTime.now(),
      category: OtherIncomeCategoryModel.fromJson(json['category'] as Map<String, dynamic>? ?? {}),
      // **PERBAIKAN 2: Ambil data dari JSON. Asumsi key API adalah 'proof_image_link'**
      proofImageLink: json['proof_image_link'] as String?,
    );
  }
}

class OtherIncomeCategoryModel {
  final int id;
  final String name;
  final String type;

  OtherIncomeCategoryModel({
    required this.id,
    required this.name,
    required this.type,
  });

  factory OtherIncomeCategoryModel.fromJson(Map<String, dynamic> json) {
    return OtherIncomeCategoryModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Tidak Berkategori',
      type: json['type'] as String? ?? 'N/A',
    );
  }
}