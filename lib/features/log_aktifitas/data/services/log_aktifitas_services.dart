import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/activity_model.dart';

class LogAktifitasService {
  final String baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api';

  Future<List<ActivityModel>> getActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    final uri = Uri.parse('$baseUrl/activities');

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', // Sertakan token
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body['status'] == 'success') {
        final List data = body['data'];
        return data.map((json) => ActivityModel.fromJson(json)).toList();
      }
    }
    
    throw Exception('Gagal memuat aktivitas: ${response.statusCode}');
  }
}