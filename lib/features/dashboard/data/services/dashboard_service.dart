import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dashboard_model.dart';

class DashboardService {
  final String baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api';

  Future<DashboardModel> getDashboardData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    final uri = Uri.parse('$baseUrl/dashboard/main');

    print("GET Dashboard: $uri"); // Debugging

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    print("Status Code: ${response.statusCode}"); // Debugging
    print("Response Body: ${response.body}");     // Debugging

    if (response.statusCode == 200) {
      final dynamic body = json.decode(response.body);
      
      // PERBAIKAN: Langsung parsing body karena struktur JSON Anda flat (langsung object)
      // Tidak perlu cek 'status' atau 'data' karena JSON Anda tidak memilikinya di root.
      return DashboardModel.fromJson(body);
    }
    
    throw Exception('Gagal memuat dashboard: ${response.statusCode}');
  }

  // ... kode sebelumnya ...

  // GET FINANCIAL DASHBOARD
  Future<FinancialDashboardModel> getFinancialData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    // Ganti endpoint sesuai kebutuhan, misal: /dashboard/finance
    // Jika endpointnya sama dengan /dashboard/main, gunakan response yang sama.
    // Asumsi: Endpoint baru untuk detail keuangan
    final uri = Uri.parse('$baseUrl/dashboard/finance'); 

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final dynamic body = json.decode(response.body);
      // Parsing langsung body (sesuai contoh JSON Anda yang flat)
      return FinancialDashboardModel.fromJson(body);
    }
    
    throw Exception('Gagal memuat data keuangan: ${response.statusCode}');
  }

  // ... kode sebelumnya ...

  // GET POPULATION DASHBOARD
  Future<PopulationDashboardModel> getPopulationData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    // Endpoint asumsi berdasarkan pola sebelumnya
    final uri = Uri.parse('$baseUrl/dashboard/population'); 

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final dynamic body = json.decode(response.body);
      return PopulationDashboardModel.fromJson(body);
    }
    
    throw Exception('Gagal memuat data kependudukan: ${response.statusCode}');
  }

  // ... kode sebelumnya ...

  // GET ACTIVITY DASHBOARD
  Future<ActivityDashboardModel> getActivityData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    final uri = Uri.parse('$baseUrl/dashboard/activity'); 

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final dynamic body = json.decode(response.body);
      return ActivityDashboardModel.fromJson(body);
    }
    
    throw Exception('Gagal memuat data kegiatan: ${response.statusCode}');
  }
}