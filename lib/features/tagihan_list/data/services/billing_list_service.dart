// lib/features/billing/data/services/billing_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/billing_list_model.dart'; // Pastikan semua model di atas ada di sini

class BillingListService {
  final String _baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api'; 

  // ... (Fungsi createBilling yang sudah diperbaiki) ...

  // --- FUNGSI BARU: Mengambil List Tagihan ---
  Future<BillingListResponse> fetchBillings({int page = 1}) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('access_token');
    
    // API endpoint untuk mengambil data tagihan
    final uri = Uri.parse('$_baseUrl/billings?page=$page'); 

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
        // Menggunakan BillingListResponse untuk parsing data paginated
        return BillingListResponse.fromJson(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Autentikasi gagal. Sesi Anda mungkin telah berakhir.');
      } else {
        // Penanganan error lain
        String errorMessage = 'Gagal mengambil data tagihan. Status Code: ${response.statusCode}';
        try {
            final errorJson = jsonDecode(response.body);
            if (errorJson['message'] != null) {
                errorMessage = errorJson['message'] as String;
            }
        } catch (_) {
            // Biarkan pesan error default jika decoding gagal
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat koneksi: $e');
    }
  }
}