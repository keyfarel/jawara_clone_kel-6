class TransactionCategoryModel {
  final int id;
  final String name;

  TransactionCategoryModel({
    required this.id,
    required this.name,
  });

  factory TransactionCategoryModel.fromJson(Map<String, dynamic> json) {
    return TransactionCategoryModel(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }
}