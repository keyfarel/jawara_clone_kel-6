import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'models/login_request.dart';
import 'models/register_request.dart';

class AuthService {
  final String baseUrl =
      'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api';

  // --- LOGIN ---
  Future<Map<String, dynamic>> login(LoginRequest request) async {
    final uri = Uri.parse('$baseUrl/login');

    final response = await http.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: request.toMap(),
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200 && data['access_token'] != null) {
      await _saveTokens(data['access_token'], data['refresh_token']);
    }

    return data;
  }

  // --- REGISTER ---
  Future<Map<String, dynamic>> register(RegisterRequest request) async {
    final uri = Uri.parse('$baseUrl/register');

    var multipartRequest = http.MultipartRequest('POST', uri);
    multipartRequest.headers.addAll({'Accept': 'application/json'});

    multipartRequest.fields.addAll({
      'full_name': request.name,
      'nik': request.nik,
      'email': request.email,
      'phone': request.phone,
      'password': request.password,
      'password_confirmation': request.passwordConfirmation,
      'gender': request.gender,
      'ownership_status': request.ownershipStatus,
    });

    if (request.houseId != null) {
      multipartRequest.fields['house_id'] = request.houseId!;
    }

    if (request.customHouseAddress != null) {
      multipartRequest.fields['custom_house_address'] =
          request.customHouseAddress!;
    }

    if (request.idCardPhoto != null) {
      final bytes = await request.idCardPhoto!.readAsBytes();
      multipartRequest.files.add(
        http.MultipartFile.fromBytes(
          'id_card_photo',
          bytes,
          filename: request.idCardPhoto!.name,
        ),
      );
    }

    try {
      final streamedResponse = await multipartRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      return json.decode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  // --- AUTO LOGIN ---
  Future<bool> checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');
    final accessToken = prefs.getString('access_token');

    if (refreshToken == null) {
      return false;
    }

    if (accessToken != null && !JwtDecoder.isExpired(accessToken)) {
      return true;
    }

    return await _performRefreshToken(refreshToken);
  }

  Future<bool> _performRefreshToken(String refreshToken) async {
    final uri = Uri.parse('$baseUrl/refresh-token');

    try {
      final response = await http.post(
        uri,
        headers: {'Accept': 'application/json'},
        body: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['access_token'] != null && data['refresh_token'] != null) {
          await _saveTokens(data['access_token'], data['refresh_token']);
          return true;
        }

        return false;
      } else {
        await logout();
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // --- SAVE TOKENS ---
  Future<void> _saveTokens(String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', access);
    await prefs.setString('refresh_token', refresh);
  }

  // --- LOGOUT ---
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
