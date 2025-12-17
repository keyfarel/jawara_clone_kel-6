class OtherExpenseResponse {
  final bool success;
  final String message;
  final ExpenseData? data;

  OtherExpenseResponse({required this.success, required this.message, this.data});

  factory OtherExpenseResponse.fromJson(Map<String, dynamic> json) {
    return OtherExpenseResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ExpenseData.fromJson(json['data']) : null,
    );
  }
}

class ExpenseData {
  final int id;
  final String title;
  final String amount;
  final String transactionDate;
  final String? description;

  ExpenseData({
    required this.id,
    required this.title,
    required this.amount,
    required this.transactionDate,
    this.description,
  });

  factory ExpenseData.fromJson(Map<String, dynamic> json) {
    return ExpenseData(
      id: json['id'],
      title: json['title'],
      amount: json['amount'].toString(),
      transactionDate: json['transaction_date'],
      description: json['description'],
    );
  }
}