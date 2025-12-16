// lib/features/billing/controllers/billing_list_controller.dart

import 'package:flutter/material.dart';
import '../data/models/billing_list_model.dart';
import '../data/repository/billing_list_repository.dart';

enum BillingListState { initial, loading, loaded, error }

class BillingListController extends ChangeNotifier {
  final BillingListRepository _repository;
  
  BillingListController(this._repository);

  BillingListState _state = BillingListState.initial;
  BillingListState get state => _state;

  BillingListResponse? _listResponse;
  BillingListResponse? get listResponse => _listResponse;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // --- FUNGSI UTAMA: Ambil Data List ---
  Future<void> fetchBillings({int page = 1}) async {
    if (_state == BillingListState.loading) return;

    _state = BillingListState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.fetchBillings(page: page);
      _listResponse = response;
      _state = BillingListState.loaded;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = BillingListState.error;
      print('Error fetching billings: $_errorMessage'); // Logging
    } finally {
      notifyListeners();
    }
  }
  
  // Fungsi reset state jika diperlukan
  void resetState() {
    _state = BillingListState.initial;
    _errorMessage = null;
    notifyListeners();
  }
}