// lib/features/dashboard/controllers/dashboard_controller.dart

import 'package:flutter/material.dart';
import '../data/models/dashboard_model.dart';
import '../data/repository/dashboard_repository.dart';

class DashboardController extends ChangeNotifier {
  final DashboardRepository repository;

  DashboardController(this.repository);

  // --- 1. MAIN DASHBOARD ---
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
      final result = await repository.fetchDashboardData();
      _data = result;
    } catch (e) {
      print("Error Dashboard: $e");
      _errorMessage = e.toString().replaceAll("Exception: ", "");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- 2. FINANCIAL DASHBOARD ---
  FinancialDashboardModel? _financialData;
  bool _isFinancialLoading = false;

  FinancialDashboardModel? get financialData => _financialData;
  bool get isFinancialLoading => _isFinancialLoading;

  Future<void> loadFinancial({bool force = false}) async {
    if (!force && _financialData != null) return; // Cache check

    _isFinancialLoading = true;
    notifyListeners();

    try {
      final result = await repository.fetchFinancialData();
      _financialData = result;
    } catch (e) {
      print("Error Financial: $e");
    } finally {
      _isFinancialLoading = false;
      notifyListeners();
    }
  }

  // --- 3. POPULATION DASHBOARD ---
  PopulationDashboardModel? _populationData;
  bool _isPopulationLoading = false;

  PopulationDashboardModel? get populationData => _populationData;
  bool get isPopulationLoading => _isPopulationLoading;

  Future<void> loadPopulation({bool force = false}) async {
    if (!force && _populationData != null) return; // Cache check

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

  // --- 4. ACTIVITY DASHBOARD ---
  ActivityDashboardModel? _activityData;
  bool _isActivityLoading = false;

  ActivityDashboardModel? get activityData => _activityData;
  bool get isActivityLoading => _isActivityLoading;

  // PERBAIKAN: Tambah parameter {bool force = false}
  Future<void> loadActivity({bool force = false}) async {
    // LOGIC CACHING:
    // Jika tidak dipaksa refresh (force=false) DAN data sudah ada, stop.
    if (!force && _activityData != null) {
      return;
    }

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
