import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_category_model.dart';

class TransactionCategoryService {
  final String baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api';

  Future<List<TransactionCategory>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    final uri = Uri.parse('$baseUrl/transaction-categories'); 

    try {
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      final body = json.decode(response.body);

      if (response.statusCode == 200 && body['status'] == 'success') {
        final List data = body['data'];
        return data.map((item) => TransactionCategory.fromJson(item)).toList();
      } else {
        throw body['message'] ?? 'Gagal memuat kategori';
      }
    } catch (e) {
      throw Exception('Koneksi gagal: $e');
    }
  }
}