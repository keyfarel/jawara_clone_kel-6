class OtherExpenseListResponse {
  final bool success;
  final String message;
  final List<ExpenseListItem> data;

  OtherExpenseListResponse({required this.success, required this.message, required this.data});

  factory OtherExpenseListResponse.fromJson(Map<String, dynamic> json) {
    return OtherExpenseListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List?)?.map((item) => ExpenseListItem.fromJson(item)).toList() ?? [],
    );
  }
}

class ExpenseListItem {
  final int id;
  final String title;
  final String amount;
  final String transactionDate;
  final String? description;
  final String? proofImageLink;
  final ExpenseCategory? category;

  ExpenseListItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.transactionDate,
    this.description,
    this.proofImageLink,
    this.category,
  });

  factory ExpenseListItem.fromJson(Map<String, dynamic> json) {
    return ExpenseListItem(
      id: json['id'],
      title: json['title'] ?? '',
      amount: json['amount'] ?? '0',
      transactionDate: json['transaction_date'] ?? '',
      description: json['description'],
      proofImageLink: json['proof_image_link'],
      category: json['category'] != null ? ExpenseCategory.fromJson(json['category']) : null,
    );
  }
}

class ExpenseCategory {
  final int id;
  final String name;

  ExpenseCategory({required this.id, required this.name});

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }
}