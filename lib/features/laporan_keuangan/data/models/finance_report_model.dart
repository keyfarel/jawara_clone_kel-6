class FinanceReportModel {
  final ReportMeta meta;
  final List<ReportTransaction> data;

  FinanceReportModel({required this.meta, required this.data});

  factory FinanceReportModel.fromJson(Map<String, dynamic> json) {
    return FinanceReportModel(
      meta: ReportMeta.fromJson(json['meta'] ?? {}),
      data: (json['data'] as List? ?? [])
          .map((e) => ReportTransaction.fromJson(e))
          .toList(),
    );
  }
}

class ReportMeta {
  final String period;
  final double totalIncome;
  final double totalExpense;
  final double netBalance;

  ReportMeta({
    required this.period,
    required this.totalIncome,
    required this.totalExpense,
    required this.netBalance,
  });

  factory ReportMeta.fromJson(Map<String, dynamic> json) {
    return ReportMeta(
      period: json['period'] ?? '-',
      totalIncome: double.tryParse(json['total_income'].toString()) ?? 0,
      totalExpense: double.tryParse(json['total_expense'].toString()) ?? 0,
      netBalance: double.tryParse(json['net_balance'].toString()) ?? 0,
    );
  }
}

class ReportTransaction {
  final String title;
  final String type; // income / expense
  final double amount;
  final String date;
  final String categoryName;

  ReportTransaction({
    required this.title,
    required this.type,
    required this.amount,
    required this.date,
    required this.categoryName,
  });

  factory ReportTransaction.fromJson(Map<String, dynamic> json) {
    return ReportTransaction(
      title: json['title'] ?? 'Tanpa Judul',
      type: json['type'] ?? 'expense',
      amount: double.tryParse(json['amount'].toString()) ?? 0,
      date: json['transaction_date'] ?? '-',
      categoryName: json['category'] != null ? json['category']['name'] : '-',
    );
  }
}