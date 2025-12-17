import 'package:flutter/material.dart';
import '../data/models/transaction_category_model.dart';
import '../data/repository/transaction_category_repository.dart';

class TransactionCategoryController extends ChangeNotifier {
  final TransactionCategoryRepository _repository;

  TransactionCategoryController(this._repository);

  List<TransactionCategory> _allCategories = [];
  bool _isLoading = false;

  List<TransactionCategory> get allCategories => _allCategories;
  bool get isLoading => _isLoading;

  // Getter khusus untuk menyaring data secara otomatis
  List<TransactionCategory> get expenseCategories => 
      _allCategories.where((cat) => cat.type == 'expense').toList();

  List<TransactionCategory> get incomeCategories => 
      _allCategories.where((cat) => cat.type == 'income').toList();

  Future<void> loadCategories() async {
    // Hindari fetch ulang jika data sudah ada (Opsional)
    if (_allCategories.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _allCategories = await _repository.fetchCategories();
    } catch (e) {
      debugPrint("Error load categories: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi untuk memaksa refresh data dari API
  Future<void> refreshCategories() async {
    _allCategories = [];
    await loadCategories();
  }
}