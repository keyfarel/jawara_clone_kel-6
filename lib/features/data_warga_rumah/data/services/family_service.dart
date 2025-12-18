// lib/features/data_warga_rumah/data/family_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/keluarga_model.dart'; // Import model yg baru dibuat

class FamilyService {
  final String baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api';

  Future<List<KeluargaModel>> getFamilies() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final uri = Uri.parse('$baseUrl/families'); // Pastikan endpoint ini benar menampilkan JSON list keluarga
    
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
      // Cek struktur response, apakah langsung List atau dalam 'data'
      // Berdasarkan contoh JSON Anda, sepertinya langsung List [...]
      
      List data;
      if (body is List) {
        data = body;
      } else if (body['data'] != null) {
        data = body['data'];
      } else {
        return [];
      }

      return data.map((json) => KeluargaModel.fromJson(json)).toList();
    }
    
    throw Exception('Gagal load keluarga: ${response.statusCode}');
  }

  Future<bool> createFamily(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final uri = Uri.parse('$baseUrl/families');

    final response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      // Ambil pesan error dari API jika ada
      final body = json.decode(response.body);
      throw Exception(body['message'] ?? 'Gagal menambah keluarga');
    }
  }
}