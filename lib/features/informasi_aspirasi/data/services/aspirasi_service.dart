import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/aspirasi_model.dart';

class AspirasiService {
  final String baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api';

  Future<List<AspirasiModel>> getAspirasi() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    final uri = Uri.parse('$baseUrl/aspirasi'); 

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true', // Penting jika menggunakan ngrok free tier
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      // Sesuai response JSON Anda: "success": true
      if (body['success'] == true) {
        final List data = body['data'];
        return data.map((json) => AspirasiModel.fromJson(json)).toList();
      }
    }
    
    throw Exception('Gagal memuat data aspirasi: ${response.statusCode}');
  }
}