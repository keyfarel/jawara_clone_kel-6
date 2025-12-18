import 'package:flutter/material.dart';
import '../data/models/dashboard_model.dart';
import '../data/repository/dashboard_repository.dart';

class DashboardController extends ChangeNotifier {
  final DashboardRepository repository;

  DashboardController(this.repository);

  // --- Main Dashboard
  DashboardModel? _data;
  bool _isLoading = false;
  String? _errorMessage;

  DashboardModel? get data => _data;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadDashboard({bool force = false}) async {
    if (!force && _data != null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _data = await repository.fetchDashboardData();
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- Financial Dashboard
  FinancialDashboardModel? _financialData;
  bool _isFinancialLoading = false;

  FinancialDashboardModel? get financialData => _financialData;
  bool get isFinancialLoading => _isFinancialLoading;

  Future<void> loadFinancial({bool force = false}) async {
    if (!force && _financialData != null) return;

    _isFinancialLoading = true;
    notifyListeners();

    try {
      _financialData = await repository.fetchFinancialData();
    } catch (_) {} finally {
      _isFinancialLoading = false;
      notifyListeners();
    }
  }

  // --- Population Dashboard
  PopulationDashboardModel? _populationData;
  bool _isPopulationLoading = false;

  PopulationDashboardModel? get populationData => _populationData;
  bool get isPopulationLoading => _isPopulationLoading;

  Future<void> loadPopulation({bool force = false}) async {
    if (!force && _populationData != null) return;

    _isPopulationLoading = true;
    notifyListeners();

    try {
      _populationData = await repository.fetchPopulationData();
    } catch (_) {} finally {
      _isPopulationLoading = false;
      notifyListeners();
    }
  }

  // --- Activity Dashboard
  ActivityDashboardModel? _activityData;
  bool _isActivityLoading = false;

  ActivityDashboardModel? get activityData => _activityData;
  bool get isActivityLoading => _isActivityLoading;

  Future<void> loadActivity({bool force = false}) async {
    if (!force && _activityData != null) return;

    _isActivityLoading = true;
    notifyListeners();

    try {
      _activityData = await repository.fetchActivityData();
    } catch (_) {} finally {
      _isActivityLoading = false;
      notifyListeners();
    }
  }

  // --- Reset cache (dipanggil setelah update data)
  Future<void> refreshData() async {    
    loadDashboard(force: true);
    loadFinancial(force: true);
    loadPopulation(force: true);
    loadActivity(force: true);
  }
}
