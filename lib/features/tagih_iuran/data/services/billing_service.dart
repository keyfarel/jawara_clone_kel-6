// lib/features/billing/data/services/billing_service.dart

import 'dart:convert'; // Tambahkan import ini untuk menggunakan jsonEncode/jsonDecode
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/billing_model.dart';

class BillingService {
  // Pastikan baseUrl konsisten. Jika /billings adalah endpoint lengkap, tidak masalah.
  final String _baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api'; 

  Future<BillingModel> createBilling(CreateBillingPayload payload) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('access_token');
    
    final uri = Uri.parse('$_baseUrl/billings'); 

    if (token == null) {
      throw Exception('Autentikasi gagal: Access token tidak ditemukan.');
    }

    try {
      // 1. KOREKSI FATAL: Menggunakan http.post dan mengirimkan body
      final response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json', // WAJIB untuk mengirim JSON body
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode(payload.toJson()), // MENGIRIM PAYLOAD KE SERVER
      );

      // 2. BLOK SUCCESS (2xx)
      if (response.statusCode >= 200 && response.statusCode < 300) { 
        final responseModel = CreateBillingResponse.fromJson(response.body);
        
        if (responseModel.success && responseModel.billingData != null) {
           return responseModel.billingData!;
        } else {
           throw Exception('Gagal membuat tagihan: ${responseModel.message}');
        }
      } 
      
      // 3. BLOK ERROR (4xx dan 5xx)
      else {
        // Penanganan 401 (Unauthorized)
        if (response.statusCode == 401) {
             throw Exception('Autentikasi gagal. Sesi Anda mungkin telah berakhir.');
        }

        // Penanganan Error Server/Validasi (405, 422, 500)
        String errorMessage;
        try {
            final errorJson = jsonDecode(response.body);
            
            // Coba ambil pesan utama (seringkali berisi pesan duplikasi 422)
            if (errorJson['message'] != null) {
                errorMessage = errorJson['message'] as String;
            } 
            // Coba ambil error validasi rinci (Laravel menggunakan 'errors')
            else if (response.statusCode == 422 && errorJson['errors'] != null) {
                final errorsMap = errorJson['errors'] as Map<String, dynamic>;
                // Ambil pesan error pertama
                final firstKey = errorsMap.keys.first;
                final firstErrorList = errorsMap[firstKey] as List;
                errorMessage = firstErrorList.first.toString(); 
            } else {
                errorMessage = 'Gagal membuat tagihan. Status Code: ${response.statusCode}';
            }

            throw Exception(errorMessage);

        } catch (e) {
            // Jika parsing JSON gagal (misal respons server 500 dalam bentuk HTML)
            throw Exception('Terjadi kesalahan server tidak terduga. Status Code: ${response.statusCode}');
        }
      }
    } catch (e) {
      // Tangani error koneksi (timeout, no internet, dll.)
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }
}