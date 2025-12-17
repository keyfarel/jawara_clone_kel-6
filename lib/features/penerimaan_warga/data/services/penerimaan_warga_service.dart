// lib/features/penerimaan_warga/data/services/penerimaan_warga_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/penerimaan_warga_model.dart';

class PenerimaanWargaService {
  final String baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api';

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

  // 1. GET List (Index)
  Future<List<PenerimaanWargaModel>> getVerificationList() async {
    final uri = Uri.parse('$baseUrl/citizens/verification-list?status=pending');
    final response = await http.get(uri, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body['success'] == true) {
        final List data = body['data'];
        return data.map((json) => PenerimaanWargaModel.fromJson(json)).toList();
      }
    }
    throw Exception('Gagal memuat data: ${response.statusCode}');
  }

  // 2. GET Detail (Show) - Opsional jika ingin refresh data detail
  Future<PenerimaanWargaModel> getDetail(int id) async {
    final uri = Uri.parse('$baseUrl/citizens/verification-list/$id');
    final response = await http.get(uri, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return PenerimaanWargaModel.fromJson(body['data']);
    }
    throw Exception('Gagal memuat detail');
  }

  // 3. UPDATE Status (Terima/Tolak)
  Future<bool> updateStatus(int id, String status) async {
    final uri = Uri.parse('$baseUrl/citizens/verification-list/$id');
    
    final response = await http.put(
      uri,
      headers: await _getHeaders(),
      body: jsonEncode({'status': status}), // status: 'verified' atau 'rejected'
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final body = json.decode(response.body);
      throw Exception(body['message'] ?? 'Gagal memverifikasi warga');
    }
  }
}