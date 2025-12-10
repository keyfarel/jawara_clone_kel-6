import 'package:flutter/material.dart';
import '../data/models/finance_report_model.dart';
import '../data/repository/laporan_repository.dart';

class LaporanController extends ChangeNotifier {
  final LaporanRepository repository;

  LaporanController(this.repository);

  bool _isLoading = false;
  String? _errorMessage;
  FinanceReportModel? _reportResult;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  FinanceReportModel? get reportResult => _reportResult;

  Future<bool> generateReport({
    required String startDate,
    required String endDate,
    required String type,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.fetchReport(
        startDate: startDate,
        endDate: endDate,
        type: type,
      );
      _reportResult = result;
      return true;
    } catch (e) {
      // Hapus prefix "Exception: " agar pesan lebih bersih
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}