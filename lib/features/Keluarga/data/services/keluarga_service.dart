// lib/features/keluarga/data/services/keluarga_service.dart

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Tambahkan import ini
import '../models/keluarga_model.dart';

class KeluargaService {
  final String _baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api/families';
  
  // Catatan: Variabel prefs dan token dihapus dari sini.
  // Pengambilan token harus dilakukan di dalam fungsi async.

  Future<List<KeluargaModel>> fetchListKeluarga() async {
    // 1. Ambil token dari SharedPreferences di awal fungsi
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('access_token');
    
    // Penanganan jika token tidak ditemukan
    if (token == null) {
      throw Exception('Autentikasi gagal: Access token tidak ditemukan.');
    }

    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'accept': 'application/json',
          // 2. Gunakan token yang sudah didapatkan
          'Authorization': 'Bearer $token',
          // Tambahan: header ini mungkin diperlukan untuk ngrok
          'ngrok-skip-browser-warning': 'true', 
        },
      );

      if (response.statusCode == 200) {
        // Karena responsenya adalah List<Map<String, dynamic>>, kita gunakan ListKeluargaModel.fromListJson
        return ListKeluargaModel.fromListJson(response.body).families;
      } else if (response.statusCode == 401) {
        throw Exception('Autentikasi gagal. Sesi Anda mungkin telah berakhir.');
      } else {
        // Melempar exception jika status code bukan 200
        throw Exception('Gagal memuat daftar keluarga. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Melempar exception untuk error jaringan atau parsing
      throw Exception('Terjadi kesalahan saat memuat data: $e');
    }
  }
}