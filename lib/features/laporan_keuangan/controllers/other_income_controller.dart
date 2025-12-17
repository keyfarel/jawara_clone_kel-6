import 'package:flutter/material.dart';
import '../data/models/other_income_model.dart';
import '../data/repository/other_income_repository.dart';

class OtherIncomeController extends ChangeNotifier {
  final OtherIncomeRepository repository;

  OtherIncomeController(this.repository);

  List<OtherIncomeModel> _incomes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<OtherIncomeModel> get incomes => _incomes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Filter Variables
  DateTime? _startDate;
  DateTime? _endDate;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  // --- MODIFIKASI DISINI ---
  Future<void> loadIncomes({bool force = false}) async {
    // LOGIC CACHING:
    // Jika tidak dipaksa refresh (force == false) DAN data sudah ada di memory
    // Maka stop, jangan request API lagi.
    if (!force && _incomes.isNotEmpty) {
      return; 
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      String? startStr = _startDate?.toIso8601String().split('T')[0];
      String? endStr = _endDate?.toIso8601String().split('T')[0];

      final result = await repository.fetchIncomes(startDate: startStr, endDate: endStr);
      _incomes = result;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setDateFilter(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    // Saat filter berubah, data lama tidak valid. Kita HARUS force load.
    loadIncomes(force: true); 
  }

  void resetFilter() {
    _startDate = null;
    _endDate = null;
    // Reset filter juga harus force load data "Semua"
    loadIncomes(force: true);
  }
}