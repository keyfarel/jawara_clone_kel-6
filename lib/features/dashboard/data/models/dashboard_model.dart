// lib/features/dashboard/data/models/dashboard_model.dart

// ==========================================
// 1. MAIN DASHBOARD MODEL
// ==========================================
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
      population: PopulationData.fromJson(json['total_population'] ?? {}),
      totalFamilies: _parseInt(json['total_families']),
      activityStats: ActivityData.fromJson(json['total_activity'] ?? {}),
      cash: CashData.fromJson(json['cash'] ?? {}),
      newActivities: List<String>.from(json['new_activity'] ?? []),
    );
  }
}

class PopulationData {
  final int male;
  final int female;

  PopulationData({required this.male, required this.female});

  factory PopulationData.fromJson(Map<String, dynamic> json) {
    return PopulationData(
      male: _parseInt(json['male_population']),
      female: _parseInt(json['female_population']),
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
      completed: _parseInt(json['completed']),
      upcoming: _parseInt(json['upcoming']),
      ongoing: _parseInt(json['ongoing']),
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
    return CashData(
      totalCash: _parseDouble(json['total_cash']),
      income: _parseDouble(json['income']),
      expense: _parseDouble(json['expense']),
    );
  }
}

// ==========================================
// 2. FINANCIAL DASHBOARD MODEL
// ==========================================
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
    return FinancialDashboardModel(
      totalIncome: _parseDouble(json['total_income']),
      totalExpense: _parseDouble(json['total_expense']),
      totalCash: _parseDouble(json['total_cash']),
      transactions: _parseInt(json['transactions']),
      incomePerMonth: _parseMapStringDouble(json['income_per_month']),
      expensePerMonth: _parseMapStringDouble(json['expense_per_month']),
      incomePerCategory: _parseMapStringDouble(json['income_per_category']),
      expensePerCategory: _parseMapStringDouble(json['expense_per_category']),
    );
  }
}

// ==========================================
// 3. POPULATION DASHBOARD MODEL
// ==========================================
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
    return PopulationDashboardModel(
      totalFamilies: _parseInt(json['total_families']),
      totalPopulation: _parseInt(json['total_population']),
      statusDistribution: _parseMapStringInt(json['status_distribution']),
      genderDistribution: _parseMapStringInt(json['gender_distribution']),
      rolesDistribution: _parseMapStringInt(json['roles_distribution']),
      religionDistribution: _parseMapStringInt(json['religion_distribution']),
      educationLevelDistribution: _parseMapStringInt(json['education_level_distribution']),
      occupationDistribution: _parseMapStringInt(json['occupation_distribution']),
    );
  }
}

// ==========================================
// 4. ACTIVITY DASHBOARD MODEL
// ==========================================
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
    return ActivityDashboardModel(
      totalActivities: _parseInt(json['total_activities']),
      upcomingActivities: _parseInt(json['upcoming_activities']),
      ongoingActivities: _parseInt(json['ongoing_activities']),
      completeActivities: _parseInt(json['complete_activities']),
      cancelledActivities: _parseInt(json['cancelled_activities']),
      typeOfActivity: _parseMapStringInt(json['type_of_activity']),
      activitiesPerMonth: _parseMapStringInt(json['activities_per_month']),
    );
  }
}

// ==========================================
// HELPER FUNCTIONS (Safe Parsing)
// ==========================================

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  return double.tryParse(value.toString()) ?? 0.0;
}

int _parseInt(dynamic value) {
  if (value == null) return 0;
  // Handle jika API kirim string "10" atau double 10.0
  return int.tryParse(value.toString().split('.').first) ?? 0;
}

Map<String, double> _parseMapStringDouble(dynamic json) {
  if (json == null || json is! Map) return {};
  Map<String, double> result = {};
  json.forEach((key, value) {
    result[key.toString()] = _parseDouble(value);
  });
  return result;
}

Map<String, int> _parseMapStringInt(dynamic json) {
  if (json == null || json is! Map) return {};
  Map<String, int> result = {};
  json.forEach((key, value) {
    result[key.toString()] = _parseInt(value);
  });
  return result;
}