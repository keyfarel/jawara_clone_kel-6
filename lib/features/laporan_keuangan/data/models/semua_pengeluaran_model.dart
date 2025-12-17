class SemuaPengeluaranModel {
  final int id;
  final String title;
  final String amount;
  final DateTime transactionDate;
  final String categoryName;
  final String type;
  final String? description;
  final String? proofImageLink;

  SemuaPengeluaranModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.transactionDate,
    required this.categoryName,
    required this.type,
    this.description,
    this.proofImageLink,
  });

  factory SemuaPengeluaranModel.fromJson(Map<String, dynamic> json) {
    return SemuaPengeluaranModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Tanpa Judul',
      amount: json['amount'] ?? '0',
      // API mengembalikan format "2025-10-10", parse ke DateTime
      transactionDate: json['transaction_date'] != null 
          ? DateTime.parse(json['transaction_date']) 
          : DateTime.now(),
      categoryName: json['category'] != null ? json['category']['name'] : 'Umum',
      type: json['type'] ?? 'expense',
      description: json['description'],
      proofImageLink: json['proof_image_link']?.toString(),
    );
  }

  double get nominal => double.tryParse(amount) ?? 0.0;
}