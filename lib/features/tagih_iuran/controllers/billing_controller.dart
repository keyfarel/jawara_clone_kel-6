// lib/features/billing/controllers/billing_controller.dart

import 'package:flutter/material.dart';
import '../data/models/billing_model.dart';
import '../data/repository/billing_repository.dart';

enum BillingState { initial, loading, success, error }

class BillingController extends ChangeNotifier { 
  final BillingRepository _repository;

  BillingState _state = BillingState.initial;
  String? _message; // Pesan success atau error

  // Getter
  BillingState get state => _state;
  String? get message => _message;

  BillingController(this._repository);

  // Fungsi untuk membuat tagihan
  Future<void> createBilling(CreateBillingPayload payload) async {
    _state = BillingState.loading;
    _message = null;
    notifyListeners();

    try {
      await _repository.createBilling(payload);
      
      _message = 'Tagihan berhasil dibuat!';
      _state = BillingState.success;
      
    } catch (e) {
      _message = e.toString().replaceFirst('Exception: ', ''); // Membersihkan pesan
      _state = BillingState.error;
      debugPrint('Error creating billing: $e');
    } finally {
      notifyListeners();
      // Setelah berhasil/gagal, kita bisa mengembalikan state ke initial setelah beberapa saat jika perlu
      // Future.delayed(const Duration(seconds: 3), () {
      //   _state = BillingState.initial;
      //   notifyListeners();
      // });
    }
  }

  // Reset state setelah operasi selesai
  void resetState() {
    _state = BillingState.initial;
    _message = null;
    notifyListeners();
  }
}