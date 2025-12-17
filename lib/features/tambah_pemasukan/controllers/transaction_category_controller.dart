import 'package:flutter/material.dart';
import '../data/models/transaction_category_model.dart';
import '../data/repository/transaction_category_repository.dart'; // Pastikan import ini ada

class TransactionCategoryController with ChangeNotifier {
  final TransactionCategoryRepository repository;

  TransactionCategoryController(this.repository);

  List<TransactionCategoryModel> _categories = [];
  bool _isLoading = false;

  List<TransactionCategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await repository.fetchCategories(); 
    } catch (e) {
      debugPrint("Error loading categories: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}