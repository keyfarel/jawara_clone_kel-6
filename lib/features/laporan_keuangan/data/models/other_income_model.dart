class OtherIncomeModel {
  final int id;
  final String title;
  final String type;
  final double amount;
  final String date;
  final String description;
  final String? proofImageLink;
  final String categoryName;

  OtherIncomeModel({
    required this.id,
    required this.title,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
    this.proofImageLink,
    required this.categoryName,
  });

  factory OtherIncomeModel.fromJson(Map<String, dynamic> json) {
    return OtherIncomeModel(
      id: json['id'],
      title: json['title'] ?? 'Tanpa Judul',
      type: json['type'] ?? 'income',
      // Parsing string "10000.00" ke double
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      date: json['transaction_date'] ?? '-',
      description: json['description'] ?? '',
      proofImageLink: json['proof_image_link'],
      // Handle nested category object
      categoryName: (json['category'] != null && json['category']['name'] != null)
          ? json['category']['name']
          : 'Umum',
    );
  }
}