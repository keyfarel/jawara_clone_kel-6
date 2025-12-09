import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/kegiatan_model.dart';

class KegiatanService {
  final String baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api';

  Future<List<KegiatanModel>> getActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    final uri = Uri.parse('$baseUrl/activities'); 

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
      if (body['status'] == 'success') {
        final List data = body['data'];
        return data.map((json) => KegiatanModel.fromJson(json)).toList();
      }
    }
    
    throw Exception('Gagal memuat data kegiatan: ${response.statusCode}');
  }

  // ... kode sebelumnya ...

  // CREATE ACTIVITY
  Future<bool> createActivity({
    required String name,
    required String category,
    required String date, // Format: YYYY-MM-DD HH:mm:ss
    required String location,
    required String personInCharge,
    String? description,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    final uri = Uri.parse('$baseUrl/activities');

    final response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        'name': name,
        'category': category,
        'activity_date': date,
        'location': location,
        'person_in_charge': personInCharge,
        'description': description,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      final body = json.decode(response.body);
      throw Exception(body['message'] ?? 'Gagal membuat kegiatan');
    }
  }
}