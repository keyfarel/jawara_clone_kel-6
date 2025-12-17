import 'dart:convert';
import '../models/other_expense_model.dart';
import '../services/other_expense_service.dart';

class OtherExpenseRepository {
  final OtherExpenseService _service;
  OtherExpenseRepository(this._service);

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
        // Karena tidak pakai multipart, kita kirim null untuk image ke API
        'proof_image': null, 
      });

      return OtherExpenseResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return OtherExpenseResponse(success: false, message: e.toString());
    }
  }
}