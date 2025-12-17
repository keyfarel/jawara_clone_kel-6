import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OtherExpenseListService {
  final String baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api';

  // Helper untuk mendapatkan headers
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'ngrok-skip-browser-warning': 'true',
    };
  }

  // Mengambil List Data (GET)
  Future<http.Response> getExpenses() async {
    final headers = await _getHeaders();
    return await http.get(
      Uri.parse('$baseUrl/other-expenses'),
      headers: headers,
    );
  }

  // Menambah Data (POST)
  Future<http.Response> postExpense(Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    return await http.post(
      Uri.parse('$baseUrl/other-expenses'),
      headers: headers,
      body: jsonEncode(body),
    );
  }
}