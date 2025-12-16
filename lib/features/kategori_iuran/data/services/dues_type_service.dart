// lib/features/dues_type/data/services/dues_type_service.dart

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dues_type_model.dart';

class DuesTypeService {
  final String baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api';

  Future<List<DuesTypeModel>> fetchListDuesTypes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('access_token');

    // Asumsi endpoint untuk get all dues types
    final uri = Uri.parse('$baseUrl/dues-types'); 
    
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
        // Menggunakan ListDuesTypeModel untuk memparsing respons Top Level
        final responseModel = ListDuesTypeModel.fromJson(response.body);
        
        if (responseModel.success) {
            return responseModel.duesTypes;
        } else {
            throw Exception('Gagal memuat data kategori iuran: ${responseModel.message}');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Autentikasi gagal. Sesi Anda mungkin telah berakhir.');
      } else {
        throw Exception('Gagal memuat daftar kategori iuran. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat data: $e');
    }
  }
}