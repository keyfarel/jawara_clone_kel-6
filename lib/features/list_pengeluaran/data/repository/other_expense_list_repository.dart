import 'dart:convert';
import '../models/other_expense_list_model.dart'; // Model untuk fetchExpenses
import '../../../tambah_pengeluaran/data/models/other_expense_model.dart';      // Model untuk addExpense (Response)
import '../services/other_expense_list_service.dart';

class OtherExpenseListRepository {
  final OtherExpenseListService _service;

  OtherExpenseListRepository(this._service);

  // Mengambil List Pengeluaran
  Future<OtherExpenseListResponse> fetchExpenses() async {
    try {
      final response = await _service.getExpenses();
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      return OtherExpenseListResponse.fromJson(decoded);
    } catch (e) {
      return OtherExpenseListResponse(
        success: false, 
        message: 'Gagal mengambil data: $e', 
        data: []
      );
    }
  }

  // Menambah Pengeluaran Baru
  Future<OtherExpenseResponse> addExpense({
    required int categoryId,
    required String title,
    required String amount,
    required String date,
    String? description,
  }) async {
    try {
      final response = await _service.postExpense({
        'transaction_category_id': categoryId,
        'billing_id': null,
        'title': title,
        'amount': amount,
        'transaction_date': date,
        'description': description ?? '',
        'proof_image': null, 
      });

      final Map<String, dynamic> decoded = jsonDecode(response.body);
      // Pastikan kelas OtherExpenseResponse sudah didefinisikan di other_expense_model.dart
      return OtherExpenseResponse.fromJson(decoded);
    } catch (e) {
      return OtherExpenseResponse(
        success: false, 
        message: 'Gagal menambah data: $e'
      );
    }
  }
}