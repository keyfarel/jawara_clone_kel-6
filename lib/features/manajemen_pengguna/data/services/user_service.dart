import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserService {
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

  // GET USERS
  Future<List<UserModel>> getUsers() async {
    final uri = Uri.parse('$baseUrl/users');
    final headers = await _getHeaders();
    
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body['status'] == 'success') {
        final List data = body['data'];
        return data.map((json) => UserModel.fromJson(json)).toList();
      }
    }
    throw Exception('Gagal mengambil data pengguna');
  }

  // UPDATE USER
  Future<bool> updateUser(int id, Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl/users/$id');
    final headers = await _getHeaders();

    final response = await http.put(
      uri, 
      headers: headers, 
      body: jsonEncode(data)
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final body = json.decode(response.body);
      throw Exception(body['message'] ?? 'Gagal mengupdate pengguna');
    }
  }

  // DELETE USER
  Future<bool> deleteUser(int id) async {
    final uri = Uri.parse('$baseUrl/users/$id');
    final headers = await _getHeaders();

    final response = await http.delete(uri, headers: headers);

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 403) {
      throw Exception("Tidak bisa menghapus akun sendiri!");
    } else {
      throw Exception('Gagal menghapus pengguna');
    }
  }

  Future<bool> createUser(Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl/users');
    final headers = await _getHeaders();

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      final body = json.decode(response.body);
      // Menangkap pesan error spesifik jika ada (misal: email sudah terpakai)
      throw Exception(body['message'] ?? 'Gagal membuat pengguna');
    }
  }
}