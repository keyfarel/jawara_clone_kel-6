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
  List<dynamic>? _houseCache; // cache data rumah (memory)
  final String baseUrl =
      'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api';

  final Duration _timeOutDuration = const Duration(seconds: 60);

  // Login email & password
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

      // Simpan token jika login berhasil
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

  // Login menggunakan foto wajah
  Future<Map<String, dynamic>> loginFace(XFile selfiePhoto) async {
    final uri = Uri.parse('$baseUrl/login-face');

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

      final streamedResponse = await multipartRequest.send().timeout(
        _timeOutDuration,
      );
      final response = await http.Response.fromStream(streamedResponse);

      final body = json.decode(response.body);

      // Simpan token jika sukses
      if (response.statusCode == 200 && body['status'] == 'success') {
        final data = body['data'];
        if (data != null && data['access_token'] != null) {
          await _saveTokens(data['access_token'], data['refresh_token'] ?? '');
        }
      }

      return body;
    } on SocketException {
      return {
        'status': 'error',
        'message': 'Gagal terhubung. Periksa internet.',
      };
    } on TimeoutException {
      return {'status': 'error', 'message': 'Waktu habis. Coba lagi.'};
    } catch (e) {
      return {'status': 'error', 'message': 'Gagal Login Wajah: $e'};
    }
  }

  // Register + auto login
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
      
      // TAMBAHKAN INI
      'birth_place': request.birthPlace,
      'birth_date': request.birthDate,
      'religion': request.religion,
      'family_role': request.familyRole,
      'education': request.education,
      'occupation': request.occupation,
    });

    if (request.houseId != null) {
      multipartRequest.fields['house_id'] = request.houseId!;
    } else {
      // Jika House ID kosong, kirim detail rumah baru
      if (request.houseBlock != null) multipartRequest.fields['house_block'] = request.houseBlock!;
      if (request.houseNumber != null) multipartRequest.fields['house_number'] = request.houseNumber!;
      if (request.houseStreet != null) multipartRequest.fields['house_street'] = request.houseStreet!; // Mapping ke 'address' di Laravel
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

      // Auto login setelah register
      if ((response.statusCode == 201 || response.statusCode == 200) &&
          body['status'] == 'success') {
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

  // Ambil opsi rumah dengan cache
  Future<List<dynamic>> fetchHouseOptions() async {
    if (_houseCache != null && _houseCache!.isNotEmpty) {
      return _houseCache!;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cachedString = prefs.getString('house_options_cache');

      if (cachedString != null) {
        _houseCache = json.decode(cachedString);
        return _houseCache!;
      }

      final uri = Uri.parse('$baseUrl/houses/options');
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
        _houseCache = data;
        await prefs.setString('house_options_cache', json.encode(data));
        return data;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Gagal memuat data rumah: $e');
    }
  }

  // Cek token untuk auto login
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

  // Refresh access token
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
      } else if (response.statusCode == 401) {
        await logout();
      }

      return false;
    } catch (_) {
      return false;
    }
  }

  // Simpan token ke local storage
  Future<void> _saveTokens(String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', access);
    await prefs.setString('refresh_token', refresh);
  }

  // Logout & hapus semua data
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
