import 'package:flutter/material.dart';
import '../data/models/dashboard_model.dart';
import '../data/repository/dashboard_repository.dart';

class DashboardController extends ChangeNotifier {
  final DashboardRepository repository;

  DashboardController(this.repository);

  DashboardModel? _data;
  bool _isLoading = false;
  String? _errorMessage;

  DashboardModel? get data => _data;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadDashboard() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.fetchDashboardData();
      _data = result;
    } catch (e) {
      print("Error Dashboard: $e"); // Cek log di debug console
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ... kode sebelumnya ...

  FinancialDashboardModel? _financialData;
  bool _isFinancialLoading = false;

  FinancialDashboardModel? get financialData => _financialData;
  bool get isFinancialLoading => _isFinancialLoading;

  Future<void> loadFinancial() async {
    _isFinancialLoading = true;
    notifyListeners();

    try {
      final result = await repository.fetchFinancialData();
      _financialData = result;
    } catch (e) {
      print("Error Financial: $e");
      // Opsional: set error message terpisah
    } finally {
      _isFinancialLoading = false;
      notifyListeners();
    }
  }

  // ... kode sebelumnya ...

  PopulationDashboardModel? _populationData;
  bool _isPopulationLoading = false;

  PopulationDashboardModel? get populationData => _populationData;
  bool get isPopulationLoading => _isPopulationLoading;

  Future<void> loadPopulation() async {
    _isPopulationLoading = true;
    notifyListeners();

    try {
      final result = await repository.fetchPopulationData();
      _populationData = result;
    } catch (e) {
      print("Error Population: $e");
    } finally {
      _isPopulationLoading = false;
      notifyListeners();
    }
  }

  // ... kode sebelumnya ...

  ActivityDashboardModel? _activityData;
  bool _isActivityLoading = false;

  ActivityDashboardModel? get activityData => _activityData;
  bool get isActivityLoading => _isActivityLoading;

  Future<void> loadActivity() async {
    _isActivityLoading = true;
    notifyListeners();

    try {
      final result = await repository.fetchActivityData();
      _activityData = result;
    } catch (e) {
      print("Error Activity: $e");
    } finally {
      _isActivityLoading = false;
      notifyListeners();
    }
  }
}