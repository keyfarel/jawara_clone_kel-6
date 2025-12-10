import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/finance_report_model.dart';

class LaporanService {
  final String baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api';

  Future<FinanceReportModel> getReport({
    required String startDate, // Format harus: 2023-11-01
    required String endDate,   // Format harus: 2023-11-30
    required String type,      // Harus: all, income, atau expense
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    // Pastikan parameter query string terbentu dengan benar
    final queryParams = {
      'start_date': startDate,
      'end_date': endDate,
      'type': type,
    };

    // Gunakan Uri.https atau construct manual agar aman
    // Jika ngrok pakai https, gunakan Uri.parse dengan replace queryParameters
    final uri = Uri.parse('$baseUrl/finance/report')
        .replace(queryParameters: queryParams);

    print("Requesting Report: $uri"); // Debug URL di console

    final response = await http.get(
      uri,
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
      if (body['status'] == 'success') {
        return FinanceReportModel.fromJson(body);
      }
    } else if (response.statusCode == 422) {
      // --- PENANGANAN KHUSUS ERROR VALIDASI (422) ---
      final body = json.decode(response.body);
      String errorMessage = "Validasi Gagal:\n";
      
      if (body['errors'] != null) {
        (body['errors'] as Map).forEach((key, value) {
          errorMessage += "- $key: ${(value as List).first}\n";
        });
      } else {
        errorMessage += body['message'] ?? 'Data tidak valid';
      }
      
      throw Exception(errorMessage);
    }
    
    throw Exception('Gagal membuat laporan: ${response.statusCode}');
  }
}