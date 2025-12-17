import '../models/transaction_category_model.dart';
import '../services/transaction_category_service.dart';

class TransactionCategoryRepository {
  final TransactionCategoryService _service;

  TransactionCategoryRepository(this._service);

  Future<List<TransactionCategory>> fetchCategories() async {
    return await _service.getCategories();
  }
}