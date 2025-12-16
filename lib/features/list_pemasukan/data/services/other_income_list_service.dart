import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import untuk SharedPreferences
import '../models/other_income_list_model.dart';

class OtherIncomeListService {
  // Gunakan private field seperti BillingListService
  final String _baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api'; 

  Future<OtherIncomeListResponse> fetchOtherIncomes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('access_token');
    
    // API endpoint untuk mengambil data pemasukan lain
    final uri = Uri.parse('$_baseUrl/other-incomes'); 

    if (token == null) {
      throw Exception('Autentikasi gagal: Access token tidak ditemukan.');
    }

    try {
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) { 
        // Menggunakan json.decode karena model OtherIncomeListResponse dibuat dari Map
        final Map<String, dynamic> jsonBody = json.decode(response.body);
        return OtherIncomeListResponse.fromJson(jsonBody);
      } else if (response.statusCode == 401) {
        throw Exception('Autentikasi gagal. Sesi Anda mungkin telah berakhir.');
      } else {
        // Penanganan error yang lebih detail dan terstruktur
        String errorMessage = 'Gagal mengambil data pemasukan lain. Status Code: ${response.statusCode}';
        
        try {
            final errorJson = jsonDecode(response.body);
            // Cek jika API memberikan pesan error eksplisit
            if (errorJson['message'] != null) {
                errorMessage = errorJson['message'] as String;
            }
        } catch (_) {
            // Biarkan pesan error default jika decoding gagal
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      // Tangani error koneksi
      throw Exception('Terjadi kesalahan saat koneksi: $e');
    }
  }
}