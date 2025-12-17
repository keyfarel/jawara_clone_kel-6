import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_category_model.dart';

class TransactionCategoryService {
  final String baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api';

  Future<List<TransactionCategoryModel>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    final uri = Uri.parse('$baseUrl/transaction-categories'); 

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      // Sesuai response JSON Anda: "status": "success"
      if (body['status'] == 'success') {
        final List data = body['data'];
        return data.map((json) => TransactionCategoryModel.fromJson(json)).toList();
      }
    }
    
    throw Exception('Gagal memuat kategori: ${response.statusCode}');
  }
}