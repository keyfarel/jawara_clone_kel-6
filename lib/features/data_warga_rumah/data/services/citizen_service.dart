// lib/features/data_warga_rumah/data/citizen_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/citizen_model.dart';

class CitizenService {
  final String baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api';

  // Helper untuk Header
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'ngrok-skip-browser-warning': 'true',
    };
  }

  // GET LIST WARGA
  Future<List<CitizenModel>> getCitizens() async {
    final uri = Uri.parse('$baseUrl/citizens'); 
    final response = await http.get(uri, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body['status'] == 'success') {
        final List data = body['data'];
        return data.map((json) => CitizenModel.fromJson(json)).toList();
      }
    }
    throw Exception('Gagal memuat data warga: ${response.statusCode}');
  }

  // GET OPSI KELUARGA (Untuk Dropdown)
  Future<List<dynamic>> getFamilyOptions() async {
    final uri = Uri.parse('$baseUrl/families/options'); // Pastikan endpoint ini ada/sesuai
    // Jika endpoint khusus options tidak ada, bisa pakai getFamilies biasa dan ambil ID & Nama
    final response = await http.get(uri, headers: await _getHeaders());
    
    if (response.statusCode == 200) {
      return json.decode(response.body); // Asumsi return List [{id: 1, text: "Keluarga A"}]
    }
    return [];
  }

  // POST TAMBAH WARGA
  Future<bool> createCitizen(Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl/citizens');
    
    final response = await http.post(
      uri,
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      final body = json.decode(response.body);
      throw Exception(body['message'] ?? 'Gagal menambah warga');
    }
  }

  Future<List<dynamic>> getUserOptions() async {
    final uri = Uri.parse('$baseUrl/users/options'); 
    final response = await http.get(uri, headers: await _getHeaders());
    
    if (response.statusCode == 200) {
      // Return list of users: [{id: 1, name: "Admin", email: "..."}]
      return json.decode(response.body); 
    }
    return [];
  }
}