// lib/features/dashboard/data/services/dashboard_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dashboard_model.dart';

class DashboardService {
  // Ganti URL ini jika ngrok berubah
  final String baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api';

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'ngrok-skip-browser-warning': 'true',
    };
  }

  // 1. MAIN DASHBOARD
  Future<DashboardModel> getDashboardData() async {
    final uri = Uri.parse('$baseUrl/dashboard/main');
    final response = await http.get(uri, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return DashboardModel.fromJson(body);
    }
    throw Exception('Dashboard Error: ${response.statusCode}');
  }

  // 2. FINANCIAL DASHBOARD
  Future<FinancialDashboardModel> getFinancialData() async {
    final uri = Uri.parse('$baseUrl/dashboard/finance');
    final response = await http.get(uri, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return FinancialDashboardModel.fromJson(body);
    }
    throw Exception('Finance Error: ${response.statusCode}');
  }

  // 3. POPULATION DASHBOARD
  Future<PopulationDashboardModel> getPopulationData() async {
    final uri = Uri.parse('$baseUrl/dashboard/population');
    final response = await http.get(uri, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return PopulationDashboardModel.fromJson(body);
    }
    throw Exception('Population Error: ${response.statusCode}');
  }

  // 4. ACTIVITY DASHBOARD
  Future<ActivityDashboardModel> getActivityData() async {
    final uri = Uri.parse('$baseUrl/dashboard/activity');
    final response = await http.get(uri, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return ActivityDashboardModel.fromJson(body);
    }
    throw Exception('Activity Error: ${response.statusCode}');
  }
}