import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/rumah_model.dart';

class RumahService {
  final String baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api';

  Future<List<RumahModel>> getHouses() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    // Asumsi endpoint untuk get all houses
    final uri = Uri.parse('$baseUrl/houses'); 

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
        return data.map((json) => RumahModel.fromJson(json)).toList();
      }
    }
    
    throw Exception('Gagal memuat data rumah: ${response.statusCode}');
  }

  // CREATE HOUSE
  Future<bool> createHouse({
    required String houseName,
    required String ownerName,
    required String address,
    required String houseType,
    required bool hasFacilities,
    String status = 'empty', // Default
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    final uri = Uri.parse('$baseUrl/houses');

    final response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        'house_name': houseName,
        'owner_name': ownerName,
        'address': address,
        'house_type': houseType,
        'has_complete_facilities': hasFacilities,
        'status': status,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      final body = json.decode(response.body);
      throw Exception(body['message'] ?? 'Gagal menambah rumah');
    }
  }
}