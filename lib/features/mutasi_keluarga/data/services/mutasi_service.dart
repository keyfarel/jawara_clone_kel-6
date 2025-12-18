import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mutasi_model.dart';

class MutasiService {
  final String baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api';

  Future<List<MutasiModel>> getMutations() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final uri = Uri.parse('$baseUrl/mutations');

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
        return data.map((json) => MutasiModel.fromJson(json)).toList();
      }
    }
    
    throw Exception('Gagal mengambil data mutasi: ${response.statusCode}');
  }

  Future<bool> createMutation({
    required int familyId,
    int? citizenId,
    required String mutationType,
    required String date, // Format YYYY-MM-DD
    required String reason,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final uri = Uri.parse('$baseUrl/mutations');

    final response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        'family_id': familyId,
        'citizen_id': citizenId,
        'mutation_type': mutationType,
        'mutation_date': date,
        'reason': reason,
        // 'house_id': 1 // Opsional: Jika backend butuh, hardcode dulu atau ambil dari logic lain
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      final body = json.decode(response.body);
      throw Exception(body['message'] ?? 'Gagal mencatat mutasi');
    }
  }

  Future<List<Map<String, dynamic>>> getFamilyOptions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final uri = Uri.parse('$baseUrl/families/options');

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body); // Langsung List
      // Mapping ke List<Map> agar aman
      return data.map((item) => {
        'id': item['id'],
        'nama': item['family_name']
      }).toList();
    }
    return []; // Return kosong jika gagal
  }

  Future<List<Map<String, dynamic>>> getCitizensByFamily(int familyId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    // Asumsi endpoint detail keluarga: /api/families/{id}
    final uri = Uri.parse('$baseUrl/families/$familyId'); 

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
      // Struktur biasanya body['data']['citizens']
      if (body['data'] != null && body['data']['citizens'] != null) {
        return List<Map<String, dynamic>>.from(body['data']['citizens']);
      }
    }
    return [];
  }
}