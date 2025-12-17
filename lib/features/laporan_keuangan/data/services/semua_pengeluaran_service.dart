import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/semua_pengeluaran_model.dart';

class SemuaPengeluaranService {
  final String baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api';

  Future<List<SemuaPengeluaranModel>> fetchTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    // Perubahan endpoint menjadi other-expenses
    final url = Uri.parse('$baseUrl/other-expenses');

    print("Requesting Semua Pengeluaran: $url");

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      print("Status Code: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        
        if (body['success'] == true) {
          final List<dynamic> data = body['data'];
          return data.map((e) => SemuaPengeluaranModel.fromJson(e)).toList();
        } else {
          throw Exception(body['message'] ?? 'Gagal memuat data');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      print("Error in fetchTransactions: $e");
      rethrow;
    }
  }
}