import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/other_income_model.dart';

class OtherIncomeService {
  final String baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api';

  Future<List<OtherIncomeModel>> getIncomes({String? startDate, String? endDate}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    // Setup Query Parameters untuk Filter Tanggal
    Map<String, String> queryParams = {};
    if (startDate != null) queryParams['start_date'] = startDate;
    if (endDate != null) queryParams['end_date'] = endDate;

    final uri = Uri.parse('$baseUrl/other-incomes').replace(queryParameters: queryParams);

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
      if (body['success'] == true) {
        final List data = body['data'];
        return data.map((e) => OtherIncomeModel.fromJson(e)).toList();
      }
    }
    
    throw Exception('Gagal memuat data pemasukan: ${response.statusCode}');
  }
}