import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Jangan lupa import ini untuk DateFormat
import '../data/repository/other_expense_repository.dart';

enum ExpenseState { initial, loading, success, error }

class OtherExpenseController extends ChangeNotifier {
  final OtherExpenseRepository _repository;
  OtherExpenseController(this._repository);

  ExpenseState _state = ExpenseState.initial;
  ExpenseState get state => _state;

  String? _message;
  String? get message => _message;

  // PERHATIKAN: Tambahkan File? image di sini
  Future<void> addExpense({
    required int categoryId,
    required String title,
    required String amount,
    required DateTime date,
    String? description,
    File? image, // <--- Ini yang bikin error di UI kalau tidak ada
  }) async {
    _state = ExpenseState.loading;
    _message = null;
    notifyListeners();

    // Format tanggal sesuai kebutuhan API: YYYY-MM-DD
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    final result = await _repository.addExpense(
      categoryId: categoryId,
      title: title,
      amount: amount,
      date: formattedDate,
      description: description,
      // image diterima di sini, tapi karena Anda ingin cara JSON biasa, 
      // kita tidak mengirimnya ke repository (atau kirim null).
    );

    if (result.success) {
      _state = ExpenseState.success;
    } else {
      _state = ExpenseState.error;
    }
    _message = result.message;
    notifyListeners();
  }
}