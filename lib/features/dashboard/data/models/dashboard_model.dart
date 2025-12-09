class DashboardModel {
  final PopulationData population;
  final int totalFamilies;
  final ActivityData activityStats;
  final CashData cash;
  final List<String> newActivities;

  DashboardModel({
    required this.population,
    required this.totalFamilies,
    required this.activityStats,
    required this.cash,
    required this.newActivities,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      // Perhatikan key menggunakan SPASI sesuai JSON API Anda
      population: PopulationData.fromJson(json['total population'] ?? {}),
      totalFamilies: json['total families'] ?? 0,
      activityStats: ActivityData.fromJson(json['total activity'] ?? {}),
      cash: CashData.fromJson(json['cash'] ?? {}),
      newActivities: List<String>.from(json['new activity'] ?? []),
    );
  }
}

class PopulationData {
  final int male;
  final int female;

  PopulationData({required this.male, required this.female});

  factory PopulationData.fromJson(Map<String, dynamic> json) {
    return PopulationData(
      male: json['male population'] ?? 0,   // Key pakai spasi
      female: json['female population'] ?? 0, // Key pakai spasi
    );
  }

  int get total => male + female;
}

class ActivityData {
  final int completed;
  final int upcoming;
  final int ongoing;

  ActivityData({
    required this.completed,
    required this.upcoming,
    required this.ongoing,
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) {
    return ActivityData(
      completed: json['completed'] ?? 0,
      upcoming: json['upcoming'] ?? 0,
      ongoing: json['ongoing'] ?? 0,
    );
  }
  
  int get total => completed + upcoming + ongoing;
}

class CashData {
  final double totalCash;
  final double income;
  final double expense;

  CashData({
    required this.totalCash,
    required this.income,
    required this.expense,
  });

  factory CashData.fromJson(Map<String, dynamic> json) {
    // PENTING: Gunakan (json[...] as num).toDouble() agar aman 
    // jika API mengembalikan int tapi Dart butuh double.
    return CashData(
      totalCash: (json['total cash'] ?? 0).toDouble(), // Key pakai spasi
      income: (json['income'] ?? 0).toDouble(),
      expense: (json['expense'] ?? 0).toDouble(),
    );
  }
}

class FinancialDashboardModel {
  final double totalIncome;
  final double totalExpense;
  final double totalCash;
  final int transactions;
  final Map<String, double> incomePerMonth;
  final Map<String, double> expensePerMonth;
  final Map<String, double> incomePerCategory;
  final Map<String, double> expensePerCategory;

  FinancialDashboardModel({
    required this.totalIncome,
    required this.totalExpense,
    required this.totalCash,
    required this.transactions,
    required this.incomePerMonth,
    required this.expensePerMonth,
    required this.incomePerCategory,
    required this.expensePerCategory,
  });

  factory FinancialDashboardModel.fromJson(Map<String, dynamic> json) {
    // Helper untuk parsing Map<String, double>
    Map<String, double> parseMap(dynamic data) {
      if (data == null || data is! Map) return {};
      // Handle jika value berupa String ("15000.00") atau Number
      return data.map((key, value) => MapEntry(
        key.toString(), 
        double.tryParse(value.toString()) ?? 0.0
      ));
    }

    // Helper untuk parsing amount (String/Num -> double)
    double parseAmount(dynamic value) {
      return double.tryParse(value.toString()) ?? 0.0;
    }

    return FinancialDashboardModel(
      totalIncome: parseAmount(json['total_income']),
      totalExpense: parseAmount(json['total_expense']),
      totalCash: parseAmount(json['total_cash']),
      transactions: json['transactions'] ?? 0,
      
      // JSON Anda menggunakan array [] jika kosong, dan object {} jika isi.
      // Di Dart, array kosong adalah List, object adalah Map.
      // Kita perlu cek tipe datanya.
      incomePerMonth: (json['income_per_month'] is List) ? {} : parseMap(json['income_per_month']),
      expensePerMonth: (json['expense_per_month'] is List) ? {} : parseMap(json['expense_per_month']),
      incomePerCategory: (json['income_per_category'] is List) ? {} : parseMap(json['income_per_category']),
      expensePerCategory: (json['expense_per_category'] is List) ? {} : parseMap(json['expense_per_category']),
    );
  }
}

// ... model DashboardModel & FinancialDashboardModel yang lama ...

// TAMBAHAN BARU: PopulationDashboardModel
class PopulationDashboardModel {
  final int totalFamilies;
  final int totalPopulation;
  final Map<String, int> statusDistribution;
  final Map<String, int> genderDistribution;
  final Map<String, int> rolesDistribution;
  final Map<String, int> religionDistribution;
  final Map<String, int> educationLevelDistribution;
  final Map<String, int> occupationDistribution;

  PopulationDashboardModel({
    required this.totalFamilies,
    required this.totalPopulation,
    required this.statusDistribution,
    required this.genderDistribution,
    required this.rolesDistribution,
    required this.religionDistribution,
    required this.educationLevelDistribution,
    required this.occupationDistribution,
  });

  factory PopulationDashboardModel.fromJson(Map<String, dynamic> json) {
    // Helper parsing Map<String, int>
    Map<String, int> parseDist(dynamic data) {
      if (data == null || data is! Map) return {};
      return data.map((key, value) => MapEntry(
        key.toString(), 
        int.tryParse(value.toString()) ?? 0
      ));
    }

    return PopulationDashboardModel(
      totalFamilies: json['total_families'] ?? 0,
      totalPopulation: json['total_population'] ?? 0,
      statusDistribution: parseDist(json['status_distribution']),
      genderDistribution: parseDist(json['gender_distribution']),
      rolesDistribution: parseDist(json['roles_distribution']),
      religionDistribution: parseDist(json['religion_distribution']),
      educationLevelDistribution: parseDist(json['education_level_distribution']),
      occupationDistribution: parseDist(json['occupation_distribution']),
    );
  }
}

// ... model DashboardModel & FinancialDashboardModel & PopulationDashboardModel ...

// TAMBAHAN BARU: ActivityDashboardModel
class ActivityDashboardModel {
  final int totalActivities;
  final int upcomingActivities;
  final int ongoingActivities;
  final int completeActivities;
  final int cancelledActivities;
  final Map<String, int> typeOfActivity;
  final Map<String, int> activitiesPerMonth;

  ActivityDashboardModel({
    required this.totalActivities,
    required this.upcomingActivities,
    required this.ongoingActivities,
    required this.completeActivities,
    required this.cancelledActivities,
    required this.typeOfActivity,
    required this.activitiesPerMonth,
  });

  factory ActivityDashboardModel.fromJson(Map<String, dynamic> json) {
    // Helper Parsing Map<String, int>
    Map<String, int> parseMap(dynamic data) {
      if (data == null || data is! Map) return {};
      return data.map((key, value) => MapEntry(
        key.toString(), 
        int.tryParse(value.toString()) ?? 0
      ));
    }

    return ActivityDashboardModel(
      totalActivities: json['total_activities'] ?? 0,
      upcomingActivities: json['upcoming_activities'] ?? 0,
      ongoingActivities: json['ongoing_activities'] ?? 0,
      completeActivities: json['complete_activities'] ?? 0,
      cancelledActivities: json['cancelled_activities'] ?? 0,
      typeOfActivity: parseMap(json['type_of_activity']),
      activitiesPerMonth: parseMap(json['activities_per_month']),
    );
  }
}