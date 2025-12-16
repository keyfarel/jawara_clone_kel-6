// Untuk respons dari POST /api/other-incomes

class OtherIncomePostResponse {
  final bool success;
  final String message;
  final OtherIncomePostData data;

  OtherIncomePostResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OtherIncomePostResponse.fromJson(Map<String, dynamic> json) {
    return OtherIncomePostResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? 'Terjadi kesalahan',
      data: OtherIncomePostData.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class OtherIncomePostData {
  final int id;
  final int userId;
  final int transactionCategoryId;
  final String title;
  final double amount;
  final DateTime transactionDate;
  final String? description;
  final String? proofImageLink;
  // Field lain yang ada di response (optional, tapi disarankan)
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  OtherIncomePostData({
    required this.id,
    required this.userId,
    required this.transactionCategoryId,
    required this.title,
    required this.amount,
    required this.transactionDate,
    this.description,
    this.proofImageLink,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OtherIncomePostData.fromJson(Map<String, dynamic> json) {
    // Parsing amount dari string ke double
    final amountString = json['amount'] as String? ?? '0.0';
    final parsedAmount = double.tryParse(amountString) ?? 0.0;

    // Parsing ID kategori (bisa berupa string di response, diubah ke int)
    final categoryId = int.tryParse(json['transaction_category_id'] as String? ?? '0') ?? 0;
    
    return OtherIncomePostData(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      transactionCategoryId: categoryId,
      title: json['title'] as String? ?? 'N/A',
      amount: parsedAmount,
      transactionDate: DateTime.tryParse(json['transaction_date'] as String? ?? '') ?? DateTime.now(),
      description: json['description'] as String?,
      proofImageLink: json['proof_image_link'] as String?,
      type: json['type'] as String? ?? 'income',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ?? DateTime.now(),
    );
  }
}