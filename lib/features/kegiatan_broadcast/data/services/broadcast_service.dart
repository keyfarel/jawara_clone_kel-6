import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // 💡 Import SharedPreferences
import '../models/broadcast_model.dart';

class BroadcastService {
  final String baseUrl =
      "https://unmoaning-lenora-photomechanically.ngrok-free.dev";

  // ⭐ FUNGSI HELPER UNTUK MENGAMBIL DAN MENYIAPKAN HEADER OTORISASI
  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    // Tambahkan pengamanan jika token hilang.
    if (token == null) {
      throw Exception('Access Token tidak ditemukan. Sesi berakhir.');
    }

    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token', // 🔑 KUNCI: Otorisasi
      'ngrok-skip-browser-warning': 'true',
    };
  }

  Future<List<BroadcastModel>> getBroadcasts() async {
    final headers = await _getAuthHeaders(); // Ambil header dengan token
    
    final response = await http.get(
      Uri.parse('$baseUrl/api/announcements'),
      headers: headers, // Gunakan header otorisasi
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      List data = body['data'];
      return data.map((e) => BroadcastModel.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
       // Penanganan 401 untuk memudahkan Controller
       throw Exception('401'); 
    }
    else {
      throw Exception(
          'Gagal mengambil broadcast (${response.statusCode}): ${response.body}');
    }
  }

  Future<bool> createBroadcast({
    required String title,
    required String content,
    String? imagePath,
    String? documentPath,
    Uint8List? imageBytes,
    Uint8List? documentBytes,
    String? imageName,
    String? documentName,
  }) async {
    final uri = Uri.parse('$baseUrl/api/announcements');
    final request = http.MultipartRequest('POST', uri);

    final headers = await _getAuthHeaders(); // Ambil header dengan token
    request.headers.addAll(headers); // 🔑 KUNCI: Tambahkan header ke MultipartRequest

    request.fields['title'] = title;
    request.fields['content'] = content;

    try {
      // Mobile: add files by path
      if (imagePath != null) {
        request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      }
      if (documentPath != null) {
        request.files
            .add(await http.MultipartFile.fromPath('document', documentPath));
      }

      // Web: add files by bytes
      if (imageBytes != null && imageBytes.isNotEmpty) {
        final filename = imageName ?? 'image.png';
        request.files.add(http.MultipartFile.fromBytes('image', imageBytes,
            filename: filename));
      }
      if (documentBytes != null && documentBytes.isNotEmpty) {
        final filename = documentName ?? 'document.pdf';
        request.files.add(http.MultipartFile.fromBytes('document', documentBytes,
            filename: filename));
      }

      final streamed = await request.send();
      final respStr = await streamed.stream.bytesToString();

      debugPrint('Broadcast create status: ${streamed.statusCode}');
      debugPrint('Broadcast create body: $respStr');

      if (streamed.statusCode == 201 || streamed.statusCode == 200) {
        return true;
      } else if (streamed.statusCode == 401) {
         // Penanganan 401 untuk memudahkan Controller
         throw Exception('401'); 
      } else {
        throw Exception(
            'Gagal create broadcast (${streamed.statusCode}): $respStr');
      }
    } catch (e) {
      debugPrint('Exception in createBroadcast: $e');
      rethrow;
    }
  }
}