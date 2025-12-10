import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'models/login_request.dart';
import 'models/register_request.dart';

class AuthService {
  final String baseUrl =
      'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api';

  final Duration _timeOutDuration = const Duration(seconds: 60);
Future<Map<String, dynamic>> login(LoginRequest request) async {
    final uri = Uri.parse('$baseUrl/login');

    try {
      final response = await http
          .post(
            uri,
            headers: {'Accept': 'application/json'},
            body: request.toMap(),
          )
          .timeout(_timeOutDuration);

      if (response.statusCode >= 500) {
        return {'status': 'error', 'message': 'Gangguan pada server.'};
      }

      final body = json.decode(response.body);

      if (response.statusCode == 200 && body['status'] == 'success') {
        final data = body['data'];
        if (data != null && data['access_token'] != null) {
          await _saveTokens(data['access_token'], data['refresh_token'] ?? '');
        }
      }

      return body;
    } catch (e) {
      return {'status': 'error', 'message': 'Terjadi kesalahan sistem.'};
    }
  }

  // face login
  Future<Map<String, dynamic>> loginFace(XFile selfiePhoto) async {
    final uri = Uri.parse('$baseUrl/auth/login-face');

    var multipartRequest = http.MultipartRequest('POST', uri);
    multipartRequest.headers.addAll({'Accept': 'application/json'});

    try {
      final bytes = await selfiePhoto.readAsBytes();
      multipartRequest.files.add(
        http.MultipartFile.fromBytes(
          'selfie_photo',
          bytes,
          filename: selfiePhoto.name,
        ),
      );

      final streamedResponse = await multipartRequest.send().timeout(_timeOutDuration);
      final response = await http.Response.fromStream(streamedResponse);

      final body = json.decode(response.body);

      if ((response.statusCode == 200) && body['status'] == 'success') {
        final data = body['data'];
        if (data != null && data['access_token'] != null) {
          await _saveTokens(
            data['access_token'],
            data['refresh_token'] ?? '',
          );
        }
      }

      return body;
    } on SocketException {
      return {'status': 'error', 'message': 'Gagal terhubung. Periksa internet.'};
    } on TimeoutException {
      return {'status': 'error', 'message': 'Waktu habis. Coba lagi.'};
    } catch (e) {
      return {'status': 'error', 'message': 'Gagal Login Wajah: $e'};
    }
  }
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

    if (request.selfiePhoto != null) {
      final bytes = await request.selfiePhoto!.readAsBytes();
      multipartRequest.files.add(
        http.MultipartFile.fromBytes(
          'selfie_photo',
          bytes,
          filename: request.selfiePhoto!.name,
        ),
      );
    }

    try {
      final streamedResponse = await multipartRequest.send().timeout(
        _timeOutDuration,
      );
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 500) {
        return {'status': 'error', 'message': 'Gangguan server internal.'};
      }

      final body = json.decode(response.body);

      // LOGIKA BARU: Simpan Token (Auto Login)
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (body['status'] == 'success') {
          final data = body['data'];

          if (data != null && data['access_token'] != null) {
            await _saveTokens(
              data['access_token'],
              data['refresh_token'] ?? '',
            );
          }
        }
      }

      return body;
    } on SocketException {
      return {
        'status': 'error',
        'message': 'Gagal terhubung. Periksa internet.',
      };
    } on TimeoutException {
      return {
        'status': 'error',
        'message': 'Waktu habis saat mengunggah data.',
      };
    } catch (e) {
      return {'status': 'error', 'message': 'Gagal mendaftar.'};
    }
  }

  Future<List<dynamic>> fetchHouseOptions() async {
    final uri = Uri.parse('$baseUrl/houses/options');

    try {
      final response = await http
          .get(
            uri,
            headers: {
              'Accept': 'application/json',
              'ngrok-skip-browser-warning': 'true',
            },
          )
          .timeout(_timeOutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data;
      } else {
        return [];
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on TimeoutException {
      throw Exception('Request timeout');
    } catch (e) {
      throw Exception('Gagal memuat data rumah: $e');
    }
  }

  Future<bool> checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');
    final accessToken = prefs.getString('access_token');

    if (refreshToken == null) return false;

    if (accessToken != null) {
      try {
        if (!JwtDecoder.isExpired(accessToken)) {
          return true;
        }
      } catch (_) {}
    }

    return await _performRefreshToken(refreshToken);
  }

  Future<bool> _performRefreshToken(String refreshToken) async {
    final uri = Uri.parse('$baseUrl/refresh-token');

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Accept': 'application/json',
              'ngrok-skip-browser-warning': 'true',
            },
            body: {'refresh_token': refreshToken},
          )
          .timeout(_timeOutDuration);

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final data = body['data'];

        if (data != null && data['access_token'] != null) {
          await _saveTokens(
            data['access_token'],
            data['refresh_token'] ?? refreshToken,
          );
          return true;
        }

        return false;
      } else if (response.statusCode == 401) {
        await logout();
        return false;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  Future<void> _saveTokens(String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', access);
    await prefs.setString('refresh_token', refresh);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}