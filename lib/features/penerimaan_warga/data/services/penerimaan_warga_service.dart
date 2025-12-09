import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/penerimaan_warga_model.dart';

class PenerimaanWargaService {
  final String baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api'; 

  Future<List<PenerimaanWargaModel>> getVerificationList() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final uri = Uri.parse('$baseUrl/citizens/verification-list');

    print("Fetching from: $uri"); 

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
      if (body['success'] == true) {
        final List data = body['data'];
        return data.map((json) => PenerimaanWargaModel.fromJson(json)).toList();
      }
    }
    
    throw Exception('Gagal memuat data verifikasi warga');
  }

  // Tambahan: Method Verifikasi (Accept/Reject) - Opsional dulu
  Future<bool> verifyCitizen(int id, String status) async {
    // Implementasi PUT/POST ke backend untuk update status
    return true; 
  }
}