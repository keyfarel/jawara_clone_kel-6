import '../models/transaction_category_model.dart';
import '../services/transaction_category_service.dart';

class TransactionCategoryRepository {
  final TransactionCategoryService service;

  TransactionCategoryRepository(this.service);

  Future<List<TransactionCategoryModel>> fetchCategories() async {
    try {
      return await service.getCategories();
    } catch (e) {
      rethrow;
    }
  }
}