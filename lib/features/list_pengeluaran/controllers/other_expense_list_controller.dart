import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models/other_expense_list_model.dart';
import '../data/repository/other_expense_list_repository.dart';

enum ExpenseState { initial, loading, success, error }

class OtherExpenseListController extends ChangeNotifier {
  final OtherExpenseListRepository _repository;

  OtherExpenseListController(this._repository);

  ExpenseState _state = ExpenseState.initial;
  ExpenseState get state => _state;

  String? _message;
  String? get message => _message;

  List<ExpenseListItem> _expenseList = [];
  List<ExpenseListItem> get expenseList => _expenseList;

  // Method Mendapatkan List Data
  Future<void> loadExpenses() async {
    _state = ExpenseState.loading;
    notifyListeners();

    final result = await _repository.fetchExpenses();

    if (result.success) {
      _expenseList = result.data;
      _state = ExpenseState.success;
    } else {
      _state = ExpenseState.error;
      _message = result.message;
    }
    notifyListeners();
  }

  // Method Tambah Data
  Future<void> addExpense({
    required int categoryId,
    required String title,
    required String amount,
    required DateTime date,
    String? description,
    File? image, // Parameter diterima agar UI tidak error
  }) async {
    _state = ExpenseState.loading;
    notifyListeners();

    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    final result = await _repository.addExpense(
      categoryId: categoryId,
      title: title,
      amount: amount,
      date: formattedDate,
      description: description,
    );

    if (result.success) {
      _state = ExpenseState.success;
      _message = result.message;
      loadExpenses(); // Refresh list otomatis setelah tambah
    } else {
      _state = ExpenseState.error;
      _message = result.message;
    }
    notifyListeners();
  }
}