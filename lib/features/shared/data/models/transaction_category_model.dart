class TransactionCategory {
  final int id;
  final String name;
  final String type; // 'income' atau 'expense'

  TransactionCategory({
    required this.id,
    required this.name,
    required this.type,
  });

  factory TransactionCategory.fromJson(Map<String, dynamic> json) {
    return TransactionCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
    );
  }
}